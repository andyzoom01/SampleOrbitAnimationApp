//
//  ImmersiveView.swift
//  SampleOrbitAnimationApp
//
//  Created by Andrew Hall on 7/4/24.
//

import SwiftUI
import RealityKit
import Starship

struct ImmersiveView: View {
    
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow
    
    //var starshipEntity : Entity = Entity()
    
    var body: some View {
        
        RealityView { content, attachments  in
            //Skybox Entity
            guard let skyBoxEntity = createSkyBox() else {
                print("Error loading skyBoxEntity")
                return
            }
            
            //Get Earth model
            let earthEntity = await createEarthModel()
            
            //Get Starship model
            let starshipEntity = await createStarshipModel()
            
            // Retrieve the attachment with the "Exit Button" identifier as an entity.
           guard let exitButton = attachments.entity(for: "Exit Button") else { return }
            exitButton.setPosition([0.0, 0.5, -2.0], relativeTo: earthEntity)
            exitButton.setScale([4.0, 4.0, 4.0], relativeTo: starshipEntity)
            
            //Add to RealityView
            content.add(skyBoxEntity)
            content.add(starshipEntity)
            content.add(earthEntity)
            content.add(exitButton)
            
           // let starshipOrbitEntity : Entity = Entity()
            
           // starshipOrbitEntity.addChild(starshipEntity)
            
            //Playing an orbit transform animation
            let orbit = OrbitAnimation(name: "Orbit",
                                       duration: 30,
                                       axis: [0, 1, 0],
                                       startTransform: starshipEntity.transform,
                                       bindTarget: .transform,
                                       repeatMode: .repeat)
            
            if let animation = try? AnimationResource.generate(with: orbit) {
                starshipEntity.playAnimation(animation)
            }
                
            //content.add(starshipOrbitEntity)
                
            /*
            starshipEntity.availableAnimations.forEach { animation in
                starshipEntity.playAnimation(animation.repeat(), transitionDuration: 3)
            }
             */

        } attachments: {
            Attachment(id: "Exit Button") {
                Button {
                    Task {
                        await dismissImmersiveSpace()
                    }
                } label: {
                    Label("Close Starship Orbit View", systemImage: "arrow.down.right.and.arrow.up.left")
                }
            }
        }

        .onAppear {
            dismissWindow(id: "ContentView")
        }
        
        .onDisappear {
            openWindow(id: "ContentView")
        }
    }
    
    private func createSkyBox () -> Entity? {
        //Mesh
        let largeSphere = MeshResource.generateSphere(radius: 1000)
        
        //Material
        var skyBoxMaterial = UnlitMaterial()
        
        do {
            let texture = try TextureResource.load(named: "Starfield")
            skyBoxMaterial.color = .init(texture: .init(texture))
        } catch {
            print("Error loading texture \(error)")
        }
        
        //SkyBox Entity
        let skyBoxEntity = Entity()
        skyBoxEntity.components.set(
            ModelComponent(
                mesh: largeSphere,
                materials: [skyBoxMaterial])
        )
        
        //Map texture to inner sphere
        skyBoxEntity.scale *= .init(x: -1, y: 1, z: 1)
        
        return skyBoxEntity
    }
    
    private func createEarthModel () async -> Entity {
        guard let earthEntity = try? await Entity(named: "Earth", in: starshipBundle) else {
            fatalError("Cannot load Earth model")
        }
        //await earthEntity.setScale(SIMD3<Float>(5,5,5), relativeTo: nil)
        
        return earthEntity
    }
     
    private func createStarshipModel () async -> Entity {
        guard let starshipEntity = try? await Entity(named: "Vessel", in: starshipBundle) else {
            fatalError("Cannot load Starship model")
        }
        return starshipEntity
    }

}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}

