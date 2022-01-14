//
//  CTARCLView.swift
//  CrustyTour
//
//  Created by Madelaine Boyd on 1/13/22.
//

import Foundation

import Foundation
import RealityKit
import ARKit
import ARKit_CoreLocation

class CTARCLView: UIViewController, ARSCNViewDelegate {
    var arView: ARSCNView {
       return self.view as! ARSCNView
    }
    var sceneLocationView: SceneLocationView {
        return SceneLocationView()
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
        let material = SCNMaterial()
        material.transparency = 0.5
        material.diffuse.contents = UIColor.magenta
        material.ambient.contents = UIColor.green
        material.lightingModel = .constant
        let torus = SCNTorus(ringRadius: 0.4, pipeRadius: 0.1)
        torus.firstMaterial = material
        let torusNode = SCNNode(geometry: torus)
        torusNode.position = SCNVector3(0, 0, -0.2) // SceneKit/AR coordinates are in meters
        arView.scene.rootNode.addChildNode(torusNode)
       
        let location = CLLocationCoordinate2DMake(39.23965369024172, -120.06924041182108)
        let geoAnchor = ARGeoAnchor(coordinate: location)
        arView.session.add(anchor: geoAnchor)
    }
    

    // MARK: - Functions for standard AR view handling
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
        self.sceneLocationView.frame = view.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       let configuration = ARWorldTrackingConfiguration()
        
        configuration.worldAlignment = .gravityAndHeading
        
        arView.session.run(configuration, options: [.resetTracking])
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
    
    func renderer(_ renderer: SCNSceneRenderer,
                 didAdd node: SCNNode,
                  for anchor: ARAnchor) {
            
        guard let geoAnchor = anchor as? ARGeoAnchor,
                  geoAnchor.name == "Geo Anchor"
        else { return }
        
        print(geoAnchor.coordinate)
                
        let boxGeometry = SCNBox(width: 1.0,
                                height: 1.0,
                                length: 1.0,
                         chamferRadius: 0.1)

        boxGeometry.firstMaterial?.diffuse.contents = UIColor.red

        let cube = SCNNode(geometry: boxGeometry)
        
        node.addChildNode(cube)
    }

}
