//
//  GameViewController.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    let scene = GameScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scene.size = view.frame.size
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
