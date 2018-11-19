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
    var planeNode: SCNNode?
    
    let angleLabel = NSTextField(labelWithString: "Angle")
    let cameraLabel = NSTextField(labelWithString: "Camera")

    var cameraPosition: SCNVector3 {
        let scnView = self.view as! SCNView
        return scnView.pointOfView!.position
    }
    
    var cameraDirection: SCNVector3 {
        let scnView = self.view as! SCNView
        return SCNVector3(x: -scnView.pointOfView!.transform.m31, y: -scnView.pointOfView!.transform.m32, z: -scnView.pointOfView!.transform.m33)
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
        
        let boxGeometry = SCNBox(width: 4, height: 10, length: 4, chamferRadius: 0)
        boxGeometry.firstMaterial?.diffuse.contents = NSColor.red
        self.box = SCNNode(geometry: boxGeometry)
        self.box.name = "box"
        self.box.worldPosition = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(self.box)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.debugOptions = .showCameras
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
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (timer) in
            guard let self = self else { return }
            self.cameraLabel.stringValue = "\(scnView.pointOfView!.position.x) \n \(scnView.pointOfView!.position.y) \n \(scnView.pointOfView!.position.z)"
            self.cameraNode.worldPosition = scnView.pointOfView!.position
        }
    }
    
    @objc func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        let scnView = self.view as! SCNView
        
        let point = gestureRecognizer.location(in: scnView)
        
        let hitResults = scnView.hitTest(point, options: [:])
        for result in hitResults {
            if result.node.name == "box" {
                self.setupPlane(for: result.worldCoordinates)
            }
        }
    }
    
    func setupPlane() {
        let plane = SCNPlane(width: 10, height: 10)
        plane.firstMaterial?.isDoubleSided = true
        self.planeNode = SCNNode(geometry: plane)
        
        guard let planeNode = self.planeNode else { return }
        planeNode.name = "Plane"
        let scnView = self.view as! SCNView
        scnView.scene?.rootNode.addChildNode(planeNode)
    }
    
    func setupPlane(for point: SCNVector3) {
        if self.planeNode != nil {
            self.planeNode?.removeFromParentNode()
            self.planeNode = nil
        }
        
        self.setupPlane()
        
        guard let planeNode = self.planeNode else { return }
        
        let translationX = point.x
        let translationY = point.y
        let translationZ = point.z
        let translationTransform = SCNMatrix4MakeTranslation(translationX, translationY, translationZ)

        let cameraToTargetX = point.x - self.cameraPosition.x
        let cameraToTargetY = point.y - self.cameraPosition.y
        let cameraToTargetZ = point.z - self.cameraPosition.z
        let cameraToTarget = SCNVector3(x: cameraToTargetX, y: cameraToTargetY, z: cameraToTargetZ).normalized
        
        let cameraToTargetSin = cameraToTarget.y / cameraToTarget.length
        let cameraToTargetAngle = -asin(cameraToTargetSin)
        angleLabel.stringValue = "\(cameraToTargetAngle * 180 / CGFloat.pi)"
        
//        let rotationAxis = SCNVector3(cameraToTarget.x, 0, cameraToTarget.z).perpendicular
        let rotationAxis = SCNVector3(cameraDirection.x, 0, cameraDirection.z).perpendicular

        let rotationTransform = SCNMatrix4MakeRotation(CGFloat.pi / 2, rotationAxis.x, rotationAxis.y, rotationAxis.z)
        
        let transform = SCNMatrix4Mult(rotationTransform, planeNode.transform)
        planeNode.transform = SCNMatrix4Mult(transform, translationTransform)
    }
}
