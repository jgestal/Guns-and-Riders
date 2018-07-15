//
//  GameViewController.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 12/1/17.
//  Copyright © 2017 Juan Gestal Romani. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MenuScene(size: view.bounds.size)
        let skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsPhysics = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
