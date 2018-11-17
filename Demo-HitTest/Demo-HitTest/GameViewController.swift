//
//  GameViewController.swift
//  Demo-HitTest
//
//  Created by Kristina Gelzinyte on 11/16/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import SceneKit
import Cocoa

class GameViewController: NSViewController {
    
    let cameraNode = SCNNode()
    var box: SCNNode!
    var planeNode: SCNNode!
    
    let angleLabel = NSTextField(labelWithString: "Angle")
    let cameraLabel = NSTextField(labelWithString: "Camera")

    var cameraPosition: SCNVector3 {
        let scnView = self.view as! SCNView
        return scnView.pointOfView!.position
    }
    
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
        
        let boxGeometry = SCNBox(width: 2, height: 10, length: 1, chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = NSColor.red
        self.box = SCNNode(geometry: boxGeometry)
        self.box.name = "box"
        self.box.worldPosition = SCNVector3(x: 0.5, y: 3, z: -1)
        scene.rootNode.addChildNode(self.box)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = NSColor.black
        
        self.angleLabel.textColor = .green
        self.view.addSubview(self.angleLabel)
        self.angleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.angleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        self.angleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.cameraLabel.textColor = .yellow
        self.view.addSubview(self.cameraLabel)
        self.cameraLabel.translatesAutoresizingMaskIntoConstraints = false
        self.cameraLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.cameraLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
        
        self.setupPlane()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (timer) in
            guard let self = self else { return }
            self.cameraLabel.stringValue = "\(scnView.pointOfView!.position.x) \n \(scnView.pointOfView!.position.y) \n \(scnView.pointOfView!.position.z)"
        }
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
        
        let cameraToPlaneX = self.box.position.x - self.cameraPosition.x
        let cameraToPlaneY = CGFloat(0)
        let cameraToPlaneZ = self.box.position.z - self.cameraPosition.z
        let cameraToPlane = SCNVector3(x: cameraToPlaneX, y: cameraToPlaneY, z: cameraToPlaneZ)
        
        let rotation = cameraToPlane.perpendicular
        
        let rotationTransform = SCNMatrix4MakeRotation(CGFloat.pi / 2, rotation.x, rotation.y, rotation.z)
        let translationTransform = SCNMatrix4MakeTranslation(self.box.position.x, self.box.position.y, self.box.position.z)
        let transform = SCNMatrix4Mult(rotationTransform, translationTransform)
        self.planeNode.transform = SCNMatrix4Mult(transform, self.planeNode.transform)
    }
    
    func adjustPlaneAngle(target point: SCNVector3) {
        let translationX = point.x - self.planeNode.position.x
        let translationY = point.y - self.planeNode.position.y
        let translationZ = point.z - self.planeNode.position.z
        let translationTransform = SCNMatrix4MakeTranslation(translationX, translationY, translationZ)
        self.planeNode.transform = SCNMatrix4Mult(planeNode.transform, translationTransform)

        let cameraToTargetX = point.x - self.cameraPosition.x
        let cameraToTargetY = point.y - self.cameraPosition.y
        let cameraToTargetZ = point.z - self.cameraPosition.z
        let cameraToTarget = SCNVector3(x: cameraToTargetX, y: cameraToTargetY, z: cameraToTargetZ)
        let rotationAxis = cameraToTarget.perpendicular
        
        let cameraToTargetNormalized = cameraToTarget.normalized
        let cameraToTargetSin = cameraToTargetNormalized.y / sqrt(pow(cameraToTargetNormalized.x, 2) + pow(cameraToTargetNormalized.y, 2) + pow(cameraToTargetNormalized.z, 2))
        let cameraToTargetAngle = -asin(cameraToTargetSin)
        angleLabel.stringValue = "\(cameraToTargetSin * 180 / CGFloat.pi)"
        
        let rotationTransform = SCNMatrix4MakeRotation(cameraToTargetAngle + CGFloat.pi / 2, rotationAxis.x, rotationAxis.y, rotationAxis.z)
        self.planeNode.eulerAngles = SCNVector3Zero
        self.planeNode.transform = SCNMatrix4Mult(rotationTransform, planeNode.transform)
        
        
//        let transformation = SCNMatrix4Mult(translationTransform, rotationTransform)
//        self.planeNode.transform = SCNMatrix4Mult( self.planeNode.transform, transformation)
        
    }
}
