//
//  Points.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 10/8/17.
//  Copyright © 2017 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class GameText: SKLabelNode {
    
    static var animation : SKAction!
    
    func spawn(parentNode: SKNode, position: CGPoint, text: String) {
        
        if GameText.animation == nil {
            let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 0.2)
            let fade = SKAction.fadeAlpha(to: 0.0, duration: 0.2)
            GameText.animation = SKAction.sequence([moveUp,fade])
        }
        
        fontName = "Old_Pixel-7"
        fontSize = 40
        self.position = position
        self.text = text
        zPosition = Constants.ZPOS_GAME_TEXT
        parentNode.addChild(self)

        run(SKAction.sequence([GameText.animation, SKAction.run {
            self.removeFromParent()
        }]))
    }
}
