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
    
    var pole = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/pole.scn")!
        
        self.pole = scene.rootNode.childNode(withName: "pole", recursively: false)!
        
        let bouncingPhysicalBody = SCNPhysicsShape(node: SCNNode(geometry: SCNSphere(radius: 0.5)), options: nil)
        
        self.pole.physicsBody = SCNPhysicsBody(type: .dynamic, shape: bouncingPhysicalBody)
        self.pole.physicsBody?.isAffectedByGravity = true
        self.pole.physicsBody?.friction = 1
        self.pole.physicsBody?.restitution = 0.65
        self.pole.physicsBody?.angularDamping = 1
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
//        self.sceneView.scene.physicsWorld.contactDelegate = self
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.animateDropping(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.sceneView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addObject(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(self.animateHeightDown(_:)))
        swipeDownGestureRecognizer.direction = .down
        self.sceneView.addGestureRecognizer(swipeDownGestureRecognizer)
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(self.animateHeightUp(_:)))
        swipeUpGestureRecognizer.direction = .up
        self.sceneView.addGestureRecognizer(swipeUpGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func addObject(_ sender: UITapGestureRecognizer?) {
        if let sender = sender, sender.state == .recognized {
            let location = sender.location(in: self.sceneView)
            let hit = self.sceneView.hitTest(location, types: .estimatedHorizontalPlane)
            
            if let hitTestPosition = hit.first?.worldTransform {
                let hitMatrix = hitTestPosition.columns.3
                let hitPosition = SCNVector3(hitMatrix.x, hitMatrix.y, hitMatrix.z)
                
                let plane = Plane(with: hitPosition)
                plane.eulerAngles.x = .pi / 2
                self.sceneView.scene.rootNode.addChildNode(plane)
                
                self.pole.position = hitPosition
            }
        }
    }
    
    @objc func animateDropping(_ sender: UITapGestureRecognizer?) {
        if let sender = sender, sender.state == .recognized {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            self.pole.pivot = SCNMatrix4MakeTranslation(0, -0.25, 0)
            SCNTransaction.commit()
        }
    }
    
    @objc func animateHeightDown(_ sender: UISwipeGestureRecognizer?) {
        if let cylinder = self.pole.geometry as? SCNCylinder {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            self.pole.pivot = SCNMatrix4MakeTranslation(0, 0.5, 0)
            cylinder.height = 0
            SCNTransaction.commit()
        }
    }
    
    @objc func animateHeightUp(_ sender: UISwipeGestureRecognizer?) {
        if let cylinder = self.pole.geometry as? SCNCylinder {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            self.pole.pivot = SCNMatrix4Identity
            cylinder.height = 1
            SCNTransaction.commit()
        }
    }
}
