//
//  BadGuy.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 10/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class BadGuy: Enemy {
    
    static var baseAnimation : SKAction!
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 50, height: 85)) {
        
        if BadGuy.baseAnimation == nil {
            BadGuy.baseAnimation = GameSprite.sprites.animate(frames: ["bad_guy_walk","bad_guy_stand"], repeatForever: true, duration: 0.2)
        }
        
        super.spawn(parentNode: parentNode, position: position, size: size)
    }
    
    override func runBaseAction() {
        run(BadGuy.baseAnimation)
    }
    
    override func die() {
        
        super.die()
        self.anchorPoint = CGPoint(x: 0, y: 0)
        let deadAnimation = SKAction.group([SKAction.setTexture(GameSprite.sprites.textureNamed("bad_guy_dead")),
                                            SKAction.rotate(byAngle: xScale * 4.71239, duration: 0),])
        run(SKAction.sequence([
            deadAnimation,
            SKAction.blink(repetitions: 4),
            SKAction.run { self.removeFromParent() }]))
    }
    
    override func randomAction() -> EnemyAction {
        let random = Int.random(in: 0 ... 10)
        switch random {
        case 0...4:
            return .walk
        case 5...6:
            return .shoot
        default:
            return .wait
        }
    }
    
    override func enemyWalk() -> (CGFloat, CGFloat, Double) {
        let dx = CGFloat.random(in: -200 ... -50)
        let dy = CGFloat.random(in: -200 ... 200)
        let duration = Double.random(in: 1 ... 3)
        return (dx,dy,duration)
    }
}
