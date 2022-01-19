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
//    var arView = ARSCNView()
    var sceneView = SCNView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle.main
        let path = bundle.path(forResource:"N39W121_translate_hmm_stl", ofType: "stl")
        let url = URL(fileURLWithPath: path!)
        let asset = MDLAsset(url: url)
        let scene = SCNScene()
        let object = asset.object(at: 0)
        let node = SCNNode(mdlObject: object)
        scene.rootNode.addChildNode(node)
//        arView.delegate = self
//        arView.scene = scene
        sceneView.scene = scene
        self.view.addSubview(sceneView)
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.black
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sceneView.frame = self.view.bounds
    }
}
