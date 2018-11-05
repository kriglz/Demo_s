//
//  GameViewController.swift
//  Demo-SCNCamera-Motion
//
//  Created by Kristina Gelzinyte on 11/5/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
//    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    
    let scene = SCNScene()
    let cameraNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 15, duration: 200)))

        let move = SCNAction.moveBy(x: 0, y: 0, z: 100, duration: 20)
        let moveBack = move.reversed()
        cameraNode.runAction(SCNAction.repeatForever(SCNAction.sequence([move, moveBack])))
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0.5, y: 0.5, z: 10.5)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        buildGrid()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    func buildGrid() {
        let count = 20
        let length: CGFloat = 0.05
        let node = SCNNode(geometry: SCNBox(width: length, height: length, length: length, chamferRadius: 0))
        
        for row in 0...count {
            for column in 0...count {
                for depth in 0...count {
                    
                    let boxNode = node.flattenedClone()
                    boxNode.worldPosition = SCNVector3(-count/2 + row, -count/2 + column, -count/2 + depth)
                    scene.rootNode.addChildNode(boxNode)
                    
                    boxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: CGFloat(Int.random(in: -1...1)), y: CGFloat(Int.random(in: -1...1)), z: CGFloat(Int.random(in: -1...1)), duration: 1)))
                }
            }
        }
    }
}
