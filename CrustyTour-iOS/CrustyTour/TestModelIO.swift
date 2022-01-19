//
//  TestModelIO.swift
//  CrustyTour
//
//  Created by Madelaine Boyd on 1/18/22.
//

import Foundation
import UIKit
import ModelIO
import SceneKit
import SceneKit.ModelIO

import ARKit

class TestModelIOViewController: UIViewController, ARSCNViewDelegate {
    var arView = ARSCNView()
//    var sceneView = SCNView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle.main
        let path = bundle.path(forResource:"N39W121_translate_hmm_stl", ofType: "stl")
        let url = URL(fileURLWithPath: path!)
        let asset = MDLAsset(url: url)
        let scene = SCNScene()
        let object = asset.object(at: 0)
        let node = SCNNode(mdlObject: object)
        
//        let material = SCNMaterial()
//        material.transparency = 0.5
//        material.diffuse.contents = UIColor.magenta
//        material.ambient.contents = UIColor.green
//        material.lightingModel = .constant
       
        node.position = SCNVector3(0, 0, -0.2)
        scene.rootNode.addChildNode(node)
        arView.delegate = self
        arView.scene = scene
//        sceneView.scene = scene
//        self.view.addSubview(sceneView)
        self.view.addSubview(arView)
        arView.autoenablesDefaultLighting = true
        
//        sceneView.autoenablesDefaultLighting = true
//        sceneView.allowsCameraControl = true
//        sceneView.scene = scene
//        sceneView.backgroundColor = UIColor.black
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        arView.frame = self.view.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       let configuration = ARWorldTrackingConfiguration()
        
        configuration.worldAlignment = .gravityAndHeading
        
        arView.session.run(configuration, options: [.resetTracking])
    }
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       arView.session.pause()
    }
}
