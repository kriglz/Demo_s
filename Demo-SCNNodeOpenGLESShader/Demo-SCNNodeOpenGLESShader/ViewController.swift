//
//  ViewController.swift
//  Demo-Node-Shader
//
//  Created by Kristina Gelzinyte on 5/8/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // MARK: - Properties
    
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: - Shaders
    
    private let whiteStripesShader = [SCNShaderModifierEntryPoint.surface:
        "uniform float Scale = 12.0;\n" +
            "uniform float Width = 0.5;\n" +
            "uniform float Blend = 0.0;\n" +
            
            "vec2 position = fract(_surface.diffuseTexcoord * Scale);" +
            
            "float f1 = clamp(position.y / Blend, 0.0, 1.0);" +
            "float f2 = clamp((position.y - Width) / Blend, 0.0, 1.0);" +
            
            "f1 = f1 * (1.0 - f2);" +
            "f1 = f1 * f1 * 2.0 * (3. * 2. * f1);" +
        "_surface.diffuse = mix(vec4(1.0), vec4(0.0), f1);"
    ]
    
    private var transparentStripesShader: [SCNShaderModifierEntryPoint : String]? {
        if let shaderBundle = Bundle.main.path(forResource: "Stripes", ofType: "frag"),
            let shaderModifier = try? String(contentsOfFile: shaderBundle) {
            return [SCNShaderModifierEntryPoint.surface : shaderModifier]
        }
        return nil
    }
    
    
    private let blackColorShader = [SCNShaderModifierEntryPoint.fragment:
        "_output.color = vec4 (0.0);"
    ]
    
    private let blueReflectionShader = [SCNShaderModifierEntryPoint.fragment :
        "uniform float mixLevel = 0.5;\n" +
            "vec3 gray = vec3(dot(vec3(0.3, 0.59, 0.11), _output.color.rgb));\n" +
        "_output.color = mix(_output.color, vec4(gray, 1.0), mixLevel);"
    ]

    private var fireShader: [SCNShaderModifierEntryPoint : String]? {
        if let shaderBundle = Bundle.main.path(forResource: "Fire", ofType: "frag"),
            let shaderModifier = try? String(contentsOfFile: shaderBundle) {
            return [SCNShaderModifierEntryPoint.fragment : shaderModifier]
        }
        return nil
    }
    
    // MARK: - Nodes
    
    private lazy var circleNode: SCNNode = {
        let circle = SCNSphere(radius: 0.2)
        
        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.blue
        material.diffuse.contents = UIImage(named: "transparent")
        material.locksAmbientWithDiffuse = true
        
        circle.materials = [material]
        
        let node = SCNNode(geometry: circle)
        node.name = "node"
        
        material.shaderModifiers = transparentStripesShader
//        material.shaderModifiers = whiteStripesShader
//        material.shaderModifiers = blackColorShader
//        material.shaderModifiers = blueReflectionShader
//        material.shaderModifiers = fireShader

//            material.setValue(NSValue(scnVector3: (SCNVector3(0, 0.7, 0))), forKey: "Color1")
//            material.setValue(Float(0), forKey: "Noise")
//            material.setValue(SCNVector3(0.6, 0.1, 0), forKey: "Color2")
//            material.setValue(Float(1.2), forKey: "NoiseScale")
        
        return node
    }()
    
    private lazy var tubeNode: SCNNode = {
        let tube = SCNTube(innerRadius: 0, outerRadius: 0.05, height: 0.4)
        
        let material = SCNMaterial()
        material.locksAmbientWithDiffuse = true
        material.diffuse.contents = UIImage(named: "transparent")
        material.isDoubleSided = true
        
        tube.materials = [material]
        
        let node = SCNNode(geometry: tube)
        node.name = "tube"

        material.shaderModifiers = transparentStripesShader
        
        return node
    }()
    
    private lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        let cameraNode = SCNCamera()
        
        node.camera = cameraNode
        node.addChildNode(lightNode)
        
        return node
    }()
    
    private var lightNode: SCNNode {
        let node = SCNNode()
        
        node.light = SCNLight()
        node.light?.type = SCNLight.LightType.omni
        
        return node
    }

    // MARK: - Life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        sceneView.session.run(configuration)
        
        circleNode.position = SCNVector3(0, 0.5, -1)
        tubeNode.position = SCNVector3(0, 0, -1)
        
        sceneView.scene.rootNode.addChildNode(self.circleNode)
        sceneView.scene.rootNode.addChildNode(self.cameraNode)
        sceneView.scene.rootNode.addChildNode(self.tubeNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}
