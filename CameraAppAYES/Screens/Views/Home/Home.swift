//
//  ContentView.swift
//  CameraAppAYES
//
//  Created by matthew hermans on 27/01/2022.
//

import SwiftUI
import AVKit

struct Home: View {
    @ObservedObject var cameraViewModel = CameraViewModel()
    var body: some View {
        ZStack(alignment: .top){
            CameraView(cameraViewModel: cameraViewModel)
                .alert(item: $cameraViewModel.alertItem, content: { $0.alert })
            Text("\(cameraViewModel.recognizedObject.label) by \(Int(cameraViewModel.recognizedObject.confidence))%")
                .font(.title3.bold())
                .foregroundColor(.cyan)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
