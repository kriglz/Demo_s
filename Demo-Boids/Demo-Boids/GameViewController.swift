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
    
    // MARK: - Properties

    let scene = GameScene()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lifecycle functions

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
    
    // MARK: - Actions
    
    @IBAction func updateSpeedCoeficient(_ sender: UISlider) {
        scene.updateBoidSpeednCoeficient(to: CGFloat(sender.value))
    }
    
    @IBAction func updateSeparationCoeficient(_ sender: UISlider) {
        scene.updateBoidSeparationCoeficient(to: CGFloat(sender.value))
    }
    
    @IBAction func updateCohesionCoeficient(_ sender: UISlider) {
        scene.updateBoidCohesionCoeficient(to: CGFloat(sender.value))
    }
    
    @IBAction func updateAlignmentCoeficient(_ sender: UISlider) {
        scene.updateBoidAlignmentCoeficient(to: CGFloat(sender.value))
    }
}
