//
//  SampleOrbitAnimationAppApp.swift
//  SampleOrbitAnimationApp
//
//  Created by Andrew Hall on 7/4/24.
//

import SwiftUI

@main
struct SampleOrbitAnimationAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
