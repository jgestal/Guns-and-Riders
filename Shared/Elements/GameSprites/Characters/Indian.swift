//
//  Indian.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 10/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class Indian: Enemy {
    
    static var baseAnimation : SKAction!
    
    //*****************************
    // MARK: - Game Sprite
    //*****************************
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize =  CGSize(width: 55, height: 75)) {
        
        if Indian.baseAnimation == nil {
            Indian.baseAnimation = GameSprite.sprites.animate(frames: ["indian_stand","indian_walk"], repeatForever: true, duration: 0.2)
        }
        
        super.spawn(parentNode: parentNode, position: position, size: size)
    }
    
    override func runBaseAction() {
        run(Indian.baseAnimation)
    }
    
    override func die() {
        super.die()
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        let deadAnimation = SKAction.group([SKAction.setTexture(GameSprite.sprites.textureNamed("indian_dead")),
                                                                SKAction.rotate(byAngle: xScale * 4.71239, duration: 0),])
        run(SKAction.sequence([
             deadAnimation,
             SKAction.blink(repetitions: 4),
             SKAction.run { self.removeFromParent() }]))
    }
    
    func throwKnife () {
        removeAllActions()
        texture = GameSprite.sprites.textureNamed("indian_throw_knife")
        run(SKAction.sequence([SKAction.wait(forDuration: 0.5),Indian.baseAnimation]))
    }
    
    override func randomAction() -> EnemyAction {
        let random = Int.random(0, 10)
        switch random {
        case 0...5:
            return .walk
        case 6...9:
            return .shoot
        default:
            return .wait
        }
    }
    override func enemyWalk() -> (CGFloat, CGFloat, Double) {
        let dx = CGFloat.random(-250, -80)
        let dy = CGFloat.random(-180, 180)
        let duration = Double.random(0.5, 1.5)
        return (dx,dy,duration)
    }
}

