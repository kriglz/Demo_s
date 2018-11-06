//
//  GameScene.swift
//  Demo-SCNCamera-Motion
//
//  Created by Kristina Gelzinyte on 11/6/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import SceneKit
import GameplayKit

class GameScene: SCNScene, SCNSceneRendererDelegate {

    let cameraNode = SCNNode()
    let count = 20

    override init() {
        super.init()
        
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        self.rootNode.addChildNode(cameraNode)
//        cameraNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 15, duration: 200)))
        
//        let move = SCNAction.moveBy(x: 0, y: 0, z: 100, duration: 20)
//        let moveBack = move.reversed()
//        cameraNode.runAction(SCNAction.repeatForever(SCNAction.sequence([move, moveBack])))
        
        // place the camera
        let position = Float(count / 2)
        cameraNode.position = SCNVector3(x: position, y: position, z: position)
        
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        self.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        self.rootNode.addChildNode(ambientLightNode)

        buildGrid()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    X = x + (a * Math.cos(alpha));
//    Y = y + (b * Math.sin(alpha));
        
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
//        cameraNode.position.z -= 0.1
        
        cameraNode.position.x = Float(count/2) + Float(cos(time)) / 1
        cameraNode.position.y = Float(count/2) + Float(sin(time)) / 10
        cameraNode.position.z = Float(count/2) + Float(sin(time)) / 1

    }
    
    func buildGrid() {
        let length: CGFloat = 0.05
        let node = SCNNode(geometry: SCNBox(width: length, height: length, length: length, chamferRadius: 0))
        
        for row in 0...count {
            for column in 0...count {
                for depth in 0...count {
                    
                    let boxNode = node.flattenedClone()
                    boxNode.worldPosition = SCNVector3(-count/2 + row, -count/2 + column, -count/2 + depth)
                    self.rootNode.addChildNode(boxNode)
                    
//                    boxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: CGFloat(Int.random(in: -1...1)), y: CGFloat(Int.random(in: -1...1)), z: CGFloat(Int.random(in: -1...1)), duration: 1)))
                }
            }
        }
    }
    
    
}
