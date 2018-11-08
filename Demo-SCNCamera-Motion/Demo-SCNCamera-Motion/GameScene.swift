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
    let ambientLightNode = SCNNode()
    let count = 25
    let length: CGFloat = 0.05
    lazy var node = SCNNode(geometry: SCNBox(width: length, height: length, length: length, chamferRadius: 0))

    override init() {
        super.init()
        
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        self.rootNode.addChildNode(cameraNode)

        // place the camera
        let position: Float = 0.0
        cameraNode.position = SCNVector3(x: position, y: position, z: position)
        
        let action = SCNAction.rotateBy(x: CGFloat.pi * 2, y: CGFloat.pi * 2, z: CGFloat.pi * 2, duration: 500)
        cameraNode.runAction(SCNAction.repeatForever(action))
        
        let move = SCNAction.moveBy(x: 0, y: 0, z: 1, duration: 100)
        let moveBack = move.reversed()
        cameraNode.runAction(SCNAction.repeatForever(SCNAction.sequence([move, moveBack])))
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        self.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        self.rootNode.addChildNode(ambientLightNode)

        buildGrid()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        cameraNode.position.x = Float(cos(time / Double.pi))

        ambientLightNode.light!.color = UIColor(red: CGFloat.random(in: 0.7...1), green: CGFloat.random(in: 0...1), blue: 0.5, alpha: 1)
        background.contents = UIColor(red: CGFloat.random(in: 0.7...1), green: CGFloat.random(in: 0...1), blue: 0.5, alpha: 1)
    }
    
    func buildGrid() {
        let container = SCNNode()
        for row in 0...count {
            for column in 0...count {
                for depth in 0...count {
                    let boxNode = node.flattenedClone()
                    boxNode.worldPosition = SCNVector3(-count/2 + row, -count/2 + column, -count/2 + depth)
                    container.addChildNode(boxNode)
                }
            }
        }
        
        self.rootNode.addChildNode(container.flattenedClone())
    }
}
