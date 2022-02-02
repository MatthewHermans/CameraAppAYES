//
//  CameraViewController.swift
//  CameraAppAYES
//
//  Created by matthew hermans on 29/01/2022.
//

import UIKit
import AVFoundation
import Vision

@MainActor class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var session = AVCaptureSession()
    @Published var preview = AVCaptureVideoPreviewLayer()
    @Published var alertItem: AlertItem?
    @Published var authorized : Bool = false
    @Published var recognizedObject: RecognizedObject = RecognizedObject(label: "", confidence: 0.0)
    private var recognizedObjects: [RecognizedObject] = []
    
    func startupChecks() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                StartCamera()
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.StartCamera()
                    } else {
                        DispatchQueue.main.async { self.alertItem = alertContext.notAuthorized }
                    }
                }
            case .denied: // The user has previously denied access.
                alertItem = alertContext.notAuthorized
            case .restricted:
                return
            @unknown default:
                StartCamera()
            }
    }
    
    func StartCamera() {
        do {
            let device = AVCaptureDevice.default(for: .video)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if session.canAddInput(input) { session.addInput(input) }
            
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraViewModel"))
            output.alwaysDiscardsLateVideoFrames = true // discard late incoming frames
            session.sessionPreset = .hd1920x1080
            
            if session.canAddOutput(output) { session.addOutput(output) }
        } catch {
            alertItem = alertContext.cantAccesCamera
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let modelURL = Bundle.main.url(forResource: "AYES_classification", withExtension: "mlmodelc") else { return }
        
        do {
            let model = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            recognizedObjects = try ObjectRecognizer().recognize(fromPixelBuffer: pixelBuffer, model: model)
            
            DispatchQueue.main.async {
                self.recognizedObject = self.recognizedObjects.first ?? RecognizedObject(label: "", confidence: 0.0)
                if self.recognizedObject.label.contains("monitor") { hapticManager.playCrossOver() }
            }
        } catch {
            alertItem = alertContext.cantAccesModel
        }
    }
}
