//
//  GameViewController.swift
//  Demo-HitTest
//
//  Created by Kristina Gelzinyte on 11/16/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    let cameraNode = SCNNode()
    var box: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        box = scene.rootNode.childNode(withName: "box", recursively: true)!
        box.position = SCNVector3(x: 0.5, y: 1, z: -1)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
        
        setupPlane()
    }
    
    @objc func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        let scnView = self.view as! SCNView
        
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            
            
        }
    }
    
    func setupPlane() {
        let plane = SCNPlane(width: 10, height: 10)
        plane.firstMaterial?.isDoubleSided = true
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "Plane"
        let scnView = self.view as! SCNView
        scnView.scene?.rootNode.addChildNode(planeNode)
        
        let planeTransform = SCNMatrix4Identity
        planeNode.transform = planeTransform
        

        let cameraToPlaneX = box.position.x - cameraNode.position.x
        let cameraToPlaneY = box.position.y - cameraNode.position.y
        let cameraToPlaneZ = box.position.z - cameraNode.position.z
        
        let cameraToPlane = SCNVector3(x: cameraToPlaneX, y: cameraToPlaneY, z: cameraToPlaneZ).normalized
        
        let rotationX = cameraToPlane.z
        let rotationY = cameraToPlane.y
        let rotationZ = -cameraToPlane.x
        
        let rotationTransform = SCNMatrix4MakeRotation(CGFloat.pi / 2, rotationX, rotationY, rotationZ)
        planeNode.transform = SCNMatrix4Mult(rotationTransform, planeNode.transform)
        
        
        let translationTransform = SCNMatrix4MakeTranslation(box.position.x, box.position.y, box.position.z)
        planeNode.transform = SCNMatrix4Mult(translationTransform, planeNode.transform)

    }
}
