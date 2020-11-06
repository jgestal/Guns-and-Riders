//
//  MenuScene.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 7/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    let ground = Ground()
    
    var startGameButtonBox : SKSpriteNode!
    var creditsBox: SKSpriteNode!
    var hiScoresBox: SKSpriteNode!
    var canShowHiScores = false
    var hiScoresShowed = false
    
    override func didMove(to view: SKView) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameCenterAutenticateNotification),
                                               name: NSNotification.Name(rawValue: GameCenterHelper.GCAuthenticateNotification),
                                               object: nil)
        
        SoundBox.shared.playMusic(music: "menu", numberOfLoops: 0)
        
        backgroundColor = UIColor(red:0.61, green:0.25, blue:0.18, alpha:1.0)
        setupGround()
        
        let w = size.width
        let h = size.height
        let zoom : CGFloat = Constants.DEVICE == .pad ? 5 : 4
        ground.position = CGPoint(x: 0, y: h / 2 - ground.tileHeight)
        
        let animDuration = 2.0
        
        let sun = placeSpriteNode("sun", parent: self)
        sun.position = CGPoint(x: 0.8 * w, y: ground.position.y + ground.tileHeight - sun.size.height / 2)
        sun.run(SKAction.move(to: CGPoint(x: 0.8 * w, y: ground.position.y + ground.tileHeight + sun.size.height / 2), duration: animDuration))
        sun.zPosition = -1
        
        let cowboy = placeSpriteNode("bw_cowboy_stand", parent: self)
        cowboy.position = CGPoint(x: 0.2 * w, y: ground.position.y + ground.tileHeight)
        
        let badGuy = placeSpriteNode("bw_bad_guy_stand", parent: self)
        badGuy.position = CGPoint(x: 0.8 * w, y:  ground.position.y + ground.tileHeight)
        
        let leftCloud = placeSpriteNode("cloud",parent: self)
        leftCloud.position = CGPoint( x: leftCloud.size.width/2, y: h - leftCloud.size.height / 2)
        
        let rightCloud = placeSpriteNode("cloud",  parent: self)
        rightCloud.xScale = -1
        rightCloud.position = CGPoint(x: w - rightCloud.size.width / 2, y: h - rightCloud.size.height / 2)
        
        let title = placeSpriteNode("guns_and_riders",  parent: self)
        title.position = CGPoint(x: 0.5 * w, y: h + title.size.height)
        title.run(SKAction.move(to: CGPoint(x: 0.5 * w, y: 0.8 * h), duration: animDuration))
        
        let leftCactus = placeSpriteNode("cactus_1", parent: self)
        leftCactus.position = CGPoint(x: 0.15 * w, y: leftCactus.size.height / 2)
        
        let rightCactus = placeSpriteNode("cactus_2", parent: self)
        rightCactus.position = CGPoint(x: 0.85 * w, y: rightCactus.size.height / 2)
        
        startGameButtonBox = placeSpriteNode("start_game_box", parent: self)
        startGameButtonBox.position = CGPoint(x: 0.5 * w, y: 0.8 * h - title.size.height)
        //startGameButtonBox.isHidden = true
        
        _ = placeLabelNode("START GAME", fontSize: 10 * zoom, parent: startGameButtonBox, name: "StartGame")
        startGameButtonBox.alpha = 0
        startGameButtonBox.name = "StartGame"
        
        creditsBox = placeSpriteNode("option_box", parent: self)
        creditsBox.position = CGPoint(x: 0.5 * w, y: startGameButtonBox.position.y - startGameButtonBox.size.height - 20)
        //creditsBox.isHidden = true
        _ = placeLabelNode("SALOON", fontSize: 6 * zoom, parent: creditsBox, name: "Credits")
        creditsBox.alpha = 0
        creditsBox.name = "Credits"
        
        hiScoresBox = placeSpriteNode("option_box", parent: self)
        hiScoresBox.position = CGPoint(x: 0.5 * w, y: creditsBox.position.y - startGameButtonBox.size.height)
        
        _ = placeLabelNode("HI-SCORES", fontSize: 6 * zoom, parent: hiScoresBox, name: "Scores")
        hiScoresBox.alpha = 0
        hiScoresBox.name = "Scores"
        
        let fadeAnimation = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.4)
        let scaleDown = SKAction.scale(to: 0.95, duration: 0.4)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        
        startGameButtonBox.run(SKAction.wait(forDuration: 2.0)) {
            self.startGameButtonBox.run(SKAction.repeatForever(fadeAnimation))
            self.startGameButtonBox.run(SKAction.wait(forDuration: 0.5)) {
                self.startGameButtonBox.run(SKAction.repeatForever(scaleSequence))
            }
        }
        
        creditsBox.run(SKAction.wait(forDuration: 2.5)) {
            self.creditsBox.run(fadeAnimation)
        }
        
        creditsBox.run(SKAction.wait(forDuration: 3.0)) {
            self.creditsBox.run(fadeAnimation)
            self.canShowHiScores = true
            self.hiScoresBox.run(fadeAnimation)
            self.hiScoresShowed = true
            self.showOrHideHiScores()
        }
    }
    
    func setupGround() {
        let size = CGSize(width: self.size.width, height: 0)
        ground.spawn(parentNode: self, position: CGPoint(x: 0, y: 0), size: size)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodeTouched = atPoint(location)
        
        if let name = nodeTouched.name {
            switch name {
            case "StartGame":
                let scene = GameScene(size: size)
                scene.scaleMode = scaleMode
                self.view?.presentScene(scene)
            case "Credits":
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = CreditsScane(size: size)
                scene.scaleMode = scaleMode
                
                self.view?.presentScene(scene, transition:reveal)
            case "Scores":
                print("Hi-Scores")
                showLeaderBoard()
            default:
                break
            }
        }
    }
}

extension MenuScene : GKGameCenterControllerDelegate {
    
    @objc func gameCenterAutenticateNotification() {
        if canShowHiScores {
            if hiScoresShowed {
                hiScoresBox.isHidden = false
            } else {
                let fadeAnimation = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
                hiScoresBox.isHidden = false
                hiScoresBox.alpha = 0
                hiScoresBox.run(fadeAnimation)
                hiScoresShowed = true
            }
        }
    }
    
    func showOrHideHiScores() {
        hiScoresBox.isHidden = !GameCenterHelper.shared.isAuthenticated()
    }
    
    func showLeaderBoard () {
        let gameCenter = GKGameCenterViewController()
        gameCenter.gameCenterDelegate = self
        gameCenter.viewState = GKGameCenterViewControllerState.leaderboards
        if let gameViewController = self.view?.window?.rootViewController {
            gameViewController.show(gameCenter, sender: self)
            gameViewController.navigationController?.pushViewController(gameCenter, animated: true)
        }
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}



