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
        node.light?.type = .spot
        
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
