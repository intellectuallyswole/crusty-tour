import UIKit
import SceneKit
import SceneKit.ModelIO

var greeting = "Hello, playground"

print("hello")

let image = UIImage.init(named:"IMG_4480.png")
image
let image2 = UIImage.init(named:"greencircles.png")

let bundle = Bundle.main
let path = bundle.path(forResource:"N39W121_translate_hmm_stl", ofType: "stl")
let url = URL(fileURLWithPath: path!)
let asset = MDLAsset(url: url)
let mesh_obj = asset.object(at:0)
guard let mesh_mesh = mesh_obj as? MDLMesh else {
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

let texcoordSource = mesh_geometry.sources(for: .texcoord)
let material = mesh_geometry.firstMaterial!
material.transparency = 0.9
//        let texture_img = UIImage.init(named:"N39W121-slope-012422-slope-colormap.png")
let texture_img = UIImage.init(named:"blue.png")
material.diffuse.contents = texture_img

//        material.emission.contents = texture_img
material.diffuse.wrapS = .repeat
material.diffuse.wrapT = .repeat
material.isDoubleSided = true
// ???
//        material.ambient.contents = UIColor.black
//        material.lightingModel = .constant

//        mesh_geometry.firstMaterial = material
// Not sure if this line is necessary
node = SCNNode(geometry: mesh_geometry)
node.rotation =  SCNVector4(x:1, y:0, z:0, w:-.pi/2)
node.scale =  SCNVector3(x:0.1,y:0.1,z:0.1)
node.position = SCNVector3(x: 10, y: -20, z: -30)

let width = 3601
let height = 3601
var vertices: [SIMD3<Float>] = []
var normals: [SIMD3<Float>] = []
var uvs: [SIMD2<Float>] = []
var indices: [UInt32] = []

for y in 0..<height {
    for x in 0..<width {
        let p = SIMD3<Float>(Float(x), 0, Float(y))
        vertices.append(p)
        normals.append(SIMD3<Float>(0, 1, 0))
        uvs.append(SIMD2<Float>(p.x / Float(width), p.z / Float(height)))
    }
}
let device = Metal.MTLCreateSystemDefaultDevice()!
let uvBuffer = device.makeBuffer(bytes: uvs,
                                 length: uvs.count * MemoryLayout<SIMD2<Float>>.size,
                                 options: [.cpuCacheModeWriteCombined])
let uvSource = SCNGeometrySource(buffer: uvBuffer!,
                                 vertexFormat: .float2,
                                 semantic: .texcoord,
                                 vertexCount: uvs.count,
                                 dataOffset: 0,
                                 dataStride: MemoryLayout<SIMD2<Float>>.size)
