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
        
        #if targetEnvironment(macCatalyst)
        let scene = MenuScene(size: CGSize(width: 1024 , height: 576))
        scene.scaleMode = .aspectFit
        #else
        let scene = MenuScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        #endif
        
        let skView = view as! SKView
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
    
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        (view as! SKView).scene?.pressesBegan(presses, with: event)
    }
    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        (view as! SKView).scene?.pressesChanged(presses, with: event)
    }
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        (view as! SKView).scene?.pressesCancelled(presses, with: event)
    }
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        (view as! SKView).scene?.pressesEnded(presses, with: event)
    }
}
