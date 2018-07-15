//
//  GameViewController.swift
//  Guns And Riders TV
//
//  Created by Juan Gestal Romani on 15/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        //skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
}
