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
        
        let scene = SCNScene()
        
        self.cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(self.cameraNode)
        self.cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
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
        
        let boxGeometry = SCNBox(width: 2, height: 4, length: 1, chamferRadius: 0)
        self.box = SCNNode(geometry: boxGeometry)
        self.box.name = "box"
        self.box.worldPosition = SCNVector3(x: 0.5, y: 3, z: -1)
        scene.rootNode.addChildNode(self.box)
        
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
        for result in hitResults {
            if result.node.name == "box" {
                self.adjustPlaneAngle(target: result.worldCoordinates)
            }
        }
    }
    
    func setupPlane() {
        let plane = SCNPlane(width: 10, height: 10)
        plane.firstMaterial?.isDoubleSided = true
        self.planeNode = SCNNode(geometry: plane)
        self.planeNode.name = "Plane"
        let scnView = self.view as! SCNView
        scnView.scene?.rootNode.addChildNode(self.planeNode)
        
        let planeTransform = SCNMatrix4Identity
        self.planeNode.transform = planeTransform
        
        let cameraToPlaneX = self.box.position.x - self.cameraNode.position.x
        let cameraToPlaneY = CGFloat(0)
        let cameraToPlaneZ = self.box.position.z - self.cameraNode.position.z
        let cameraToPlane = SCNVector3(x: cameraToPlaneX, y: cameraToPlaneY, z: cameraToPlaneZ)
        
        let rotation = cameraToPlane.perpendicular
        
        let rotationTransform = SCNMatrix4MakeRotation(CGFloat.pi / 2, rotation.x, rotation.y, rotation.z)
        let translationTransform = SCNMatrix4MakeTranslation(self.box.position.x, self.box.position.y, self.box.position.z)
        let transform = SCNMatrix4Mult(rotationTransform, translationTransform)
        self.planeNode.transform = SCNMatrix4Mult(transform, self.planeNode.transform)
    }
    
    func adjustPlaneAngle(target point: SCNVector3) {
        let cameraToTargetX = point.x - self.cameraNode.position.x
        let cameraToTargetY = point.y - self.cameraNode.position.y
        let cameraToTargetZ = point.z - self.cameraNode.position.z
        let cameraToTarget = SCNVector3(x: cameraToTargetX, y: cameraToTargetY, z: cameraToTargetZ)
        let rotation = cameraToTarget.perpendicular
        
        let cameraToTargetAngle = -CGFloat.pi / 6
        
        let translationX = point.x - self.planeNode.position.x
        let translationY = point.y - self.planeNode.position.y
        let translationZ = point.z - self.planeNode.position.z
        let translationTransform = SCNMatrix4MakeTranslation(translationX, translationY, translationZ)
        self.planeNode.transform = SCNMatrix4Mult(planeNode.transform, translationTransform)

        
//        let rotationTransform = SCNMatrix4MakeRotation(cameraToTargetAngle, rotation.x, rotation.y, rotation.z)
//        let transform = SCNMatrix4Mult(rotationTransform, planeNode.transform)
        
//        var planeTransfrom = planeNode.transform
//        planeTransfrom.m41 = 0
//        planeTransfrom.m42 = 0
//        planeTransfrom.m43 = 0
//
    }
}
