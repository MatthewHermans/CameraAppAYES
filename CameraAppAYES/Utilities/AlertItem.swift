//
//  AlertItem.swift
//  CameraAppAYES
//
//  Created by matthew hermans on 27/01/2022.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissbutton: Alert.Button
    
    var alert: Alert{
        Alert(title: title, message: message, dismissButton: dismissbutton)
    }
}

struct alertContext {
    static let notAuthorized = AlertItem(title: Text("App is not authorized to use camera"), message: Text("go to app settings and give permission to use camera"), dismissbutton: .default(Text("Settings"), action: {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }))
    static let cantAccesCamera = AlertItem(title: Text("can't Acces Camera"), message: Text("Cannot acces Camera at the moment, please try again later."), dismissbutton: .default(Text("OK")))
    static let cantAccesModel = AlertItem(title: Text("can't acces model"), message: Text("could not load the model in, please try again later or contact developer"), dismissbutton: .default(Text("OK")))
}
