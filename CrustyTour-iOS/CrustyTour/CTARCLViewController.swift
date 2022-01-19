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

class CTARCLViewController: UIViewController, ARSCNViewDelegate {
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
        
        let DODOWAH_BACKYARD = CLLocationCoordinate2DMake(39.23965369024172, -120.06924041182108)
        //                                              +37.75574832,       -122.43995607
        let GRAND_VIEW_AVE = CLLocationCoordinate2DMake(37.755776505037254, -122.4400525)
        let LITERALLY_RIGHT_HERE = CLLocationCoordinate2DMake(37.75574832,       -122.43995607)
        let location = CLLocation(coordinate: GRAND_VIEW_AVE, altitude: 122)
        guard let image = UIImage.init(named: "Castro") else { return; }
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = true
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        



        
//        let geoAnchor = ARGeoAnchor(coordinate: location)
//        arView.session.add(anchor: geoAnchor)
    }
    
    
    // MARK: - Functions for standard AR view handling
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
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
