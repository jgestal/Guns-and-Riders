//
//  hud.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 8/8/17.
//  Copyright © 2017 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class HUD: SKNode {
    
    let scoreText = SKLabelNode(text: "000000")
    let bulletsText = SKLabelNode(text: "100")
    
    var sprites = SKTextureAtlas.init(named: "sprites.atlas")

    func setup (screenSize: CGSize) {
    
        // Black Background
        
        let hudBackground = SKSpriteNode()
        hudBackground.texture = sprites.textureNamed("hud_background")
                
        hudBackground.size = CGSize(width: 212, height: 38)
        hudBackground.texture?.filteringMode = .nearest
        
        hudBackground.position = CGPoint(x: hudBackground.size.width / 2 + 5, y: screenSize.height - 25)
        
        self.addChild(hudBackground)
        
        // Money Icon
        
        let moneyIcon = SKSpriteNode()
        moneyIcon.texture = sprites.textureNamed("money_shadow")
        moneyIcon.size = CGSize(width: 60/3, height: 105/3)
        moneyIcon.texture!.filteringMode = .nearest
        moneyIcon.position = CGPoint(x: -85, y: 0)
        hudBackground.addChild(moneyIcon)
        
        // Score text
        scoreText.fontName = "Old_Pixel-7"
        scoreText.position = CGPoint(x: -30, y: -10)
        hudBackground.addChild(scoreText)
        
        // Bullets icon
        
        let bulletsIcon = SKSpriteNode()
        bulletsIcon.texture = sprites.textureNamed("bullets_1")
        bulletsIcon.size = CGSize(width: 20/1.5, height: 20/1.5)
        bulletsIcon.texture?.filteringMode = .nearest
        bulletsIcon.position = CGPoint(x: 35, y: 0)
        hudBackground.addChild(bulletsIcon)
        
        // Bullets text
        
        bulletsText.fontName = "Old_Pixel-7"
        bulletsText.position = CGPoint(x: 70,y: -10)
        hudBackground.addChild(bulletsText)
    }
    
    func setScore(newScore: Int) {
        // Format
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 6
        let newScoreNumber = NSNumber.init(value: newScore)
        // Set
        if let scoreStr = formatter.string(from: newScoreNumber) {
            scoreText.text = "\(scoreStr)"
        }
    }
    
    func setBullets(newBullets: Int) {
        
        // Format
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        let newNumberOfBullets = NSNumber.init(value: newBullets)
        // Set
        if let bulletsStr = formatter.string(from: newNumberOfBullets) {
            bulletsText.text = "\(bulletsStr)"
        }
    }
}

