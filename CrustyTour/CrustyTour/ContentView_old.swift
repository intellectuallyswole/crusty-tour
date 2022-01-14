//
//  ContentView.swift
//  CrustyTour
//
//  Created by Madelaine Boyd on 1/7/22.
//

import SwiftUI
import RealityKit
import SceneKit
import ARKit

// MARK: - NavigationIndicator
struct CTNavigationIndicator: UIViewControllerRepresentable {
   typealias UIViewControllerType = CTARView
   func makeUIViewController(context: Context) -> CTARView {
      return CTARView()
   }
   func updateUIViewController(_ uiViewController:
                               CTNavigationIndicator.UIViewControllerType, context:
   UIViewControllerRepresentableContext<CTNavigationIndicator>) { }
}

struct ContentView : View {
    var body: some View {
      return
          ZStack {
//            ARViewContainer().edgesIgnoringSafeArea(.all)
            CTNavigationIndicator()
      }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        
        let arView = ARView(frame: .zero)
//             Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
//         Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
//        let arView = ARSCNView(frame: .zero)
//        let torus = SCNTorus(ringRadius: 50.0, pipeRadius: 10.0)
//        let torusNode = SCNNode(geometry: torus)
//        arView.scene.rootNode.addChildNode(torusNode)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func addTorus() {
        
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
