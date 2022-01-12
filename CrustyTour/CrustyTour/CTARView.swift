//
//  CTARView.swift
//  CrustyTour
//
//  Created by Madelaine Boyd on 1/11/22.
//

import Foundation
import ARKit

import SwiftUI
// MARK: - ARViewIndicator
// See https://blog.devgenius.io/implementing-ar-in-swiftui-without-storyboards-ec529ace7ab2
struct CTARViewIndicator: UIViewControllerRepresentable {
   typealias UIViewControllerType = CTARView
   
   func makeUIViewController(context: Context) -> CTARView {
      return CTARView()
   }
   func updateUIViewController(_ uiViewController:
       CTARViewIndicator.UIViewControllerType, context:
       UIViewControllerRepresentableContext<CTARViewIndicator>) { }
}


// See https://blog.devgenius.io/implementing-ar-in-swiftui-without-storyboards-ec529ace7ab2
class CTARView: UIViewController, ARSCNViewDelegate {
    var arView: ARSCNView {
       return self.view as! ARSCNView
    }
    override func loadView() {
      self.view = ARSCNView(frame: .zero)
    }
    override func viewDidLoad() {
       super.viewDidLoad()
       arView.delegate = self
       arView.scene = SCNScene()
        
        
        let material = SCNMaterial()
        material.transparency = 0.5
        material.diffuse.contents = UIColor.magenta
        let torus = SCNTorus(ringRadius: 0.4, pipeRadius: 0.1)
        torus.firstMaterial = material
        let torusNode = SCNNode(geometry: torus)
        torusNode.position = SCNVector3(0, 0, -0.2) // SceneKit/AR coordinates are in meters
        arView.scene.rootNode.addChildNode(torusNode)
    }
    // MARK: - Functions for standard AR view handling
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       let configuration = ARWorldTrackingConfiguration()
       arView.session.run(configuration)
       arView.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       arView.session.pause()
    }
    // MARK: - ARSCNViewDelegate
    func sessionWasInterrupted(_ session: ARSession) {}

    func sessionInterruptionEnded(_ session: ARSession) {}
    func session(_ session: ARSession, didFailWithError error: Error)
    {}
    func session(_ session: ARSession, cameraDidChangeTrackingState
    camera: ARCamera) {}

}
