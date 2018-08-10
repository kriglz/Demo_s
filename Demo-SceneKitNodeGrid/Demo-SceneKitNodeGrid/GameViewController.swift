//
//  GameViewController.swift
//  Demo-SceneKitNodeGrid
//
//  Created by Kristina Gelzinyte on 8/9/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    private let scene = SCNScene()
    
    private let starImage = UIImage(named: "star")?.compress(to: CGSize(width: 10, height: 10))?.scale(to: CGSize(width: 100, height: 100))
    private lazy var starImagePixelData = starImage?.pixelColorData()
    
    private let pipeImage = UIImage(named: "pipe")?.compress(to: CGSize(width: 100, height: 100))?.scale(to: CGSize(width: 100, height: 100))
    private lazy var pipeImagePixelData = pipeImage?.pixelColorData()
    
    private lazy var originalImageView = UIImageView(image: starImage)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 4, y: 2, z: 15)
        cameraNode.rotation = SCNVector4(1, 0, 0.5, 0.25)
        
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
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        scnView.addGestureRecognizer(panGesture)
        
        generateCubeGrid()
        
        originalImageView.frame.origin = .zero
        scnView.addSubview(originalImageView)
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            flipAnimation(for: result.node)
        }
    }
    
//    var currentPanPosition: CGPoint = .zero
//
//    @objc func handlePan(_ gestureRecognizer: UIGestureRecognizer) {
//        let scnView = self.view as! SCNView
//
//        let point = gestureRecognizer.location(in: scnView)
//
//        if currentPanPosition != .zero {
//            let deltaX = point.x - currentPanPosition.x
//            let deltaY = point.y - currentPanPosition.y
//
//            print(point)
//            print(scene.rootNode.position)
//
//            scene.rootNode.position.x += Float(deltaX / 500)
//            scene.rootNode.position.y -= Float(deltaY / 500)
//        }
//
//        switch gestureRecognizer.state {
//        case .ended, .cancelled:
//            currentPanPosition = .zero
//        default:
//            currentPanPosition = point
//        }
//    }
    
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
    
    // MARK: - Node setup

    private func generateCubeGrid() {
        for index in 0..<10000 {
            addCube(index: index)
        }
    }
    
    private func addCube(index: Int) {
        let cube = setupCube()
        cube.name = "Cube"
        
        cube.simdPosition = float3(0)
        
        let division = Double(index) / 100
        let row = division.rounded(.down)
        
        var column = Double(index).truncatingRemainder(dividingBy: 100)
        column.round(.toNearestOrEven)
        
        cube.simdPosition.x += Float(column) * 0.11
        cube.simdPosition.y += Float(row) * 0.11

        if let pixelData = starImagePixelData {
            cube.geometry?.materials.first?.diffuse.contents = pixelData[index]
        }
//
//        if let pixelData = pipeImagePixelData {
//            cube.geometry?.materials.first?.diffuse.contents = pixelData[index]
//        }
        
        scene.rootNode.addChildNode(cube)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(index), execute: { [weak self] in
//            self?.flipAnimation(for: cube)
//        })
    }
    
    private func setupCube() -> SCNNode {
        let cubeWidth = CGFloat(0.1)
        
        let geometry = SCNBox(width: cubeWidth, height: cubeWidth, length: cubeWidth, chamferRadius: 0)
//        geometry.materials.first?.diffuse.contents = UIColor.red
        
        let node = SCNNode(geometry: geometry)
        
        return node
    }
    
    // MARK: - Node animation
    
    private func flipAnimation(for node: SCNNode) {
        // get its material
        let material = node.geometry!.firstMaterial!
        
        let nodeColor = material.diffuse.contents as? UIColor
        
        // highlight it
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        
        // set color to blue and rotate 360
        material.diffuse.contents = UIColor.blue
        node.rotation = SCNVector4(1, 0, 0, 3.14)
        
        // on completion - reset color to red
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.3
            
            material.diffuse.contents = nodeColor ?? UIColor.red
            
            SCNTransaction.commit()
            
            node.rotation = SCNVector4(1, 0, 0, 0)
        }
        
        SCNTransaction.commit()
    }
}
