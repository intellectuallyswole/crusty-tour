//
//  CTARCLView.swift
//  CrustyTour
//
//  Created by Madelaine Boyd on 1/13/22.
//

import CoreLocation
import Foundation
import RealityKit
import ARKit
import ARKit_CoreLocation
import ModelIO
import SceneKit
import SceneKit.ModelIO

class CTARCLViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    var sceneLocationView : SceneLocationView = SceneLocationView()
    
    func buildSceneLocationView() -> SceneLocationView {
        let newSceneLocationView = SceneLocationView.init(trackingType: .worldTracking)
        newSceneLocationView.arViewDelegate = self

        newSceneLocationView.debugOptions = [.showWorldOrigin]
        newSceneLocationView.showsStatistics = true
        newSceneLocationView.showAxesNode = false // don't need ARCL's axesNode because we're showing SceneKit's
        newSceneLocationView.autoenablesDefaultLighting = true
        return newSceneLocationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView = self.buildSceneLocationView()
        self.view.addSubview(sceneLocationView)
        
        let location = N39W121_ORIGIN_LOCATION
//        let location = DODOWAH_BACKYARD_LOCATION
        
        let locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.startUpdatingLocation()
        // Wait in delegate method for an actual location?
        guard let currentLocation = locManager.location else {
            fatalError("Could not get current location")
        }
        let translation = currentLocation.translation(toLocation: location)
        let bundle = Bundle.main
        let path = bundle.path(forResource:"CrustyTour.scnassets/N39W121_translate_hmm_obj", ofType: "obj")
        let url = URL(fileURLWithPath: path!)
        let asset = MDLAsset(url: url)
        guard let mesh_obj = asset.object(at:0) as? MDLMesh else {
            fatalError("Failed to get mesh from asset.")
        }
        let elevationMesh = SCNGeometry(mdlMesh: mesh_obj)
        let node = SCNNode(geometry: elevationMesh)
//        node.localTranslate(by: SCNVector3(x:Float(translation.longitudeTranslation), y:Float(translation.altitudeTranslation), z: Float(-1.0*translation.latitudeTranslation)))
//        node.pivot = SCNMatrix4MakeTranslation(Float(-1.0*translation.longitudeTranslation), Float(-1.0*translation.altitudeTranslation), Float(translation.latitudeTranslation))
//        let locationNode = LocationNode(location:location)
//        locationNode.addChildNode(node)
        
        // change camera.zFar?
        
        // and add it to the AR scene.
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
//        sceneLocationView.scene.rootNode.camera?.zFar = 120000
        sceneLocationView.scene.rootNode.addChildNode(node)
    }
    
    
    // MARK: - Functions for standard AR view handling
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        sceneLocationView.run()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneLocationView.pause()
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
    }
    
}
