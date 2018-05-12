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
    
    // MARK: - Nodes
    
    lazy var circleNode: SCNNode = {
        let circle = SCNSphere(radius: 0.5)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        material.locksAmbientWithDiffuse = true
        
        circle.materials = [material]
        
        let node = SCNNode(geometry: circle)
        node.name = "node"
        
//        material.specular.contents = UIColor.blue
        
//        material.shaderModifiers = [SCNShaderModifierEntryPoint.surface:
//            "uniform float Scale = 12.0;\n" +
//            "uniform float Width = 0.5;\n" +
//            "uniform float Blend = 0.0;\n" +
//
//            "vec2 position = fract(_surface.diffuseTexcoord * Scale);" +
//
//            "float f1 = clamp(position.y / Blend, 0.0, 1.0);" +
//            "float f2 = clamp((position.y - Width) / Blend, 0.0, 1.0);" +
//
//            "f1 = f1 * (1.0 - f2);" +
//            "f1 = f1 * f1 * 2.0 * (3. * 2. * f1);" +
//            "_surface.diffuse = mix(vec4(1.0), vec4(0.0), f1);"
//        ]
        
//        material.shaderModifiers = [SCNShaderModifierEntryPoint.fragment :
//            "_output.color = vec4 ( 0.0);"
//        ]
        
//        material.shaderModifiers = [SCNShaderModifierEntryPoint.fragment :
//            "uniform float mixLevel = 0.5;\n" +
//            "vec3 gray = vec3(dot(vec3(0.3, 0.59, 0.11), _output.color.rgb));\n" +
//            "_output.color = mix(_output.color, vec4(gray, 1.0), mixLevel);"
//        ]
      
//        vertex_string   = [bundle pathForResource: @"Fire" ofType: @"vert"];
//        vertex_string   = [NSString stringWithContentsOfFile: vertex_string];
                
        if let shaderBundle = Bundle.main.path(forResource: "Fire", ofType: "frag"), let shaderModifier = try? String(contentsOfFile: shaderBundle) {
            material.shaderModifiers = [SCNShaderModifierEntryPoint.fragment : shaderModifier]
        }
        
        return node
    }()
    
    lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        let cameraNode = SCNCamera()
        
        node.camera = cameraNode
        
        node.addChildNode(self.lightNode)
        
        return node
    }()
    
    lazy var lightNode: SCNNode = {
        let node = SCNNode()
        
        node.light = SCNLight()
        node.light?.type = SCNLight.LightType.omni
        
        return node
    }()

    // MARK: - Life cycle
    
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
        
        self.circleNode.position = SCNVector3(0, 0, -1)

        sceneView.scene.rootNode.addChildNode(self.circleNode)
        sceneView.scene.rootNode.addChildNode(self.cameraNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
