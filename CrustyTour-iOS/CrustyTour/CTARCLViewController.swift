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
import ModelIO
import SceneKit
import SceneKit.ModelIO

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
        

        let location = DODOWAH_BACKYARD_LOCATION
        let bundle = Bundle.main
        let path = bundle.path(forResource:"N39W121_translate_hmm_stl", ofType: "stl")
        let url = URL(fileURLWithPath: path!)
        let asset = MDLAsset(url: url)
        guard let mesh_obj = asset.object(at:0) as? MDLMesh else {
            fatalError("Failed to get mesh from asset.")
        }
        // (lldb) po ((object as! MDLMesh).submeshes![0] as! MDLSubmesh).material!
        // <MDLMaterial: 0x2812c52c0>
        var node = SCNNode(mdlObject: mesh_obj)
        guard let mesh_geometry = node.geometry else {
            fatalError("Failed to extract SCNGeometry from SCNNode")
        }
//        let texture_url = bundle.url(forResource:"N39W121-slope-012422-slope-colormap", withExtension: ".png")
        // It is dumb that you have to do this to initialize an MDLMaterial but what do I know.
//        let scatFunction = MDLScatteringFunction()
//        let material = MDLMaterial(name: "creative_name", scatteringFunction: scatFunction)
//        let property = MDLMaterialProperty(name:"slope-map", semantic: .baseColor, url: texture_url)
//        material.setProperty(property)
//        for submesh in mesh_obj.submeshes! {
//            if let submesh = submesh as? MDLSubmesh {
//                submesh.material = material
//            }
//        }
        
        let material = SCNMaterial()
        material.transparency = 1.0
        let texture_img = UIImage.init(named:"N39W121-slope-012422-slope-colormap.png")
        material.diffuse.contents = texture_img

//        material.emission.contents = texture_img
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        material.isDoubleSided = true
        // ???
        material.ambient.contents = UIColor.black
        material.lightingModel = .constant
        
        mesh_geometry.firstMaterial = material
        // Not sure if this line is necessary
        node = SCNNode(geometry: mesh_geometry)
        node.rotation =  SCNVector4(x:1, y:0, z:0, w:-.pi/2)
        node.scale =  SCNVector3(x:0.1,y:0.1,z:0.1)
        node.position = SCNVector3(x: 10, y: -20, z: -30)
        // Transform the node to a lat/long location
        let locationNode = LocationNode(location:location)
        locationNode.addChildNode(node)
        // and add it to the AR scene.
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
        
        // Here's how to add color to an SCNGeometry.
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
