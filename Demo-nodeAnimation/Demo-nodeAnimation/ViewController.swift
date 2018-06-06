//
//  ViewController.swift
//  Demo-nodeAnimation
//
//  Created by Kristina Gelzinyte on 6/6/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var shipNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        shipNode = scene.rootNode.childNode(withName: "ship", recursively: false)!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.animationAction(_:)))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func animationAction(_ sender: Any?) {
//        if sender.state == .ended {
//            let location: CGPoint = sender.location(in: sceneView)
//            let hits = self.sceneView.hitTest(location, options: nil)
//            if !hits.isEmpty{
//                let tappedNode = hits.first?.node
//            }
//        }
//        shipNode.simdPosition += float3(-1, 0, 0)
        
        let transitionAction = SCNAction.move(to: SCNVector3(float3(-1, 0, 0)), duration: 3)
        self.shipNode.runAction(transitionAction, forKey: "transition")
    }

}
