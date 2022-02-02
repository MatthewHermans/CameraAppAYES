//
//  CameraView.swift
//  CameraAppAYES
//
//  Created by matthew hermans on 27/01/2022.
//

import AVFoundation
import UIKit
import SwiftUI

struct CameraView: UIViewRepresentable {
    @ObservedObject var cameraViewModel: CameraViewModel
    func makeUIView(context: UIViewRepresentableContext<CameraView>) -> UIView {
        cameraViewModel.startupChecks()
        
        let view = UIView(frame: UIScreen.main.bounds)
        cameraViewModel.preview = AVCaptureVideoPreviewLayer(session: cameraViewModel.session)
        cameraViewModel.preview.frame = view.frame
        
        view.layer.addSublayer(cameraViewModel.preview)
        
        cameraViewModel.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<CameraView>) {
        
    }
}
