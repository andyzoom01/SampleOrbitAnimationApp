//
//  ContentView.swift
//  SampleOrbitAnimationApp
//
//  Created by Andrew Hall on 7/4/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        Button {
            //On press, present immersive view
            Task {
                await openImmersiveSpace(id: "ImmersiveSpace")
            }
            
        } label: {
            HStack {
                Text("View Immersive Space")
                Image(systemName: "visionpro")
                    .symbolEffect(.pulse)
            }
        }
    }
}

#Preview {
    ContentView()
        .previewLayout(.sizeThatFits)
}
