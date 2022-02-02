//
//  HapticManager.swift
//  CameraAppAYES
//
//  Created by matthew hermans on 31/01/2022.
//

import Foundation
import UIKit

class hapticManager {
    static func playCrossOver() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}
