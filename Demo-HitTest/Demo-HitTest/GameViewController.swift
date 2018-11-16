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
    var planeNode: SCNNode!
    
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
        box.position = SCNVector3(x: 0.5, y: 3, z: -1)
        
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
        
        self.setupPlane()
    }
    
    @objc func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        let scnView = self.view as! SCNView
        
        let point = gestureRecognizer.location(in: scnView)
        
        let hitResults = scnView.hitTest(point, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]

            self.adjustPlaneAngle(target: result.worldCoordinates)
        }
    }
    
    func setupPlane() {
        let plane = SCNPlane(width: 10, height: 10)
        plane.firstMaterial?.isDoubleSided = true
        planeNode = SCNNode(geometry: plane)
        planeNode.name = "Plane"
        let scnView = self.view as! SCNView
        scnView.scene?.rootNode.addChildNode(planeNode)
        
        let planeTransform = SCNMatrix4Identity
        planeNode.transform = planeTransform
        
        let cameraToPlaneX = box.position.x - cameraNode.position.x
        let cameraToPlaneY = CGFloat(0)
        let cameraToPlaneZ = box.position.z - cameraNode.position.z
        let cameraToPlane = SCNVector3(x: cameraToPlaneX, y: cameraToPlaneY, z: cameraToPlaneZ)
        
        let rotation = cameraToPlane.perpendicular
        
        let rotationTransform = SCNMatrix4MakeRotation(CGFloat.pi / 2, rotation.x, rotation.y, rotation.z)
        let translationTransform = SCNMatrix4MakeTranslation(box.position.x, box.position.y, box.position.z)
        let transform = SCNMatrix4Mult(rotationTransform, translationTransform)
        planeNode.transform = SCNMatrix4Mult(transform, planeNode.transform)
    }
    
    func adjustPlaneAngle(target point: SCNVector3) {
        let cameraToTargetX = point.x - cameraNode.position.x
        let cameraToTargetY = point.y - cameraNode.position.y
        let cameraToTargetZ = point.z - cameraNode.position.z
        let cameraToTarget = SCNVector3(x: cameraToTargetX, y: cameraToTargetY, z: cameraToTargetZ)
        let rotation = cameraToTarget.perpendicular
        
        let cameraToTargetAngle = -CGFloat.pi / 6
        
        let rotationTransform = SCNMatrix4MakeRotation(cameraToTargetAngle, rotation.x, rotation.y, rotation.z)
        let translationTransform = SCNMatrix4MakeTranslation(point.x, point.y, point.z)
        let transform = SCNMatrix4Mult(rotationTransform, translationTransform)
        planeNode.transform = SCNMatrix4Mult(transform, planeNode.transform)
    }
}
