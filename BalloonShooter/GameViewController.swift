//
//  GameViewController.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func loadView() {
        self.view = SKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Create the view
        if let view = self.view as! SKView? {
            // Only present if scene is not already presented
            if view.scene == nil {
                // Create and configure the scene
                let scene = MenuScene(size: view.bounds.size)
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
