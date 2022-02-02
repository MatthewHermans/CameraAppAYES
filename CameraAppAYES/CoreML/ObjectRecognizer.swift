//
//  ObjectRecognizer.swift
//  CameraAppAYES
//
//  Created by matthew hermans on 31/01/2022.
//

import Foundation
import Vision

struct RecognizedObject {
    var label:String
    var confidence:Float
}

class ObjectRecognizer {
    private let confidenceThreshold:Float = 0.8
    private var recognizedObjects: [RecognizedObject]?
    
    func recognize(fromPixelBuffer pixelBuffer:CVImageBuffer, model: VNCoreMLModel) throws -> [RecognizedObject] {
        var recognizedObjects: [RecognizedObject] = []
        let request = VNCoreMLRequest(model: model) { finishRequest, error in
            guard error == nil else { return }
            if let results = finishRequest.results as? [VNClassificationObservation] {
                for result in results {
                    if result.confidence > 0.2 {
                        let confidence = (result.confidence * 100).rounded()
                        recognizedObjects.append(RecognizedObject(label: result.identifier, confidence: confidence))
                    }
                }
            }
        }
        
        try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
        return recognizedObjects
    }
}
