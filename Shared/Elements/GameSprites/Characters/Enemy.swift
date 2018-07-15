//
//  Enemy.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 10/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

enum EnemyAction {
    case none
    case wait
    case shoot
    case walk
    case dead
}

class Enemy: Character {
    
    var action : EnemyAction = .none
    var isDead = false
    
    //*****************************
    // MARK: - Game Sprite
    //*****************************
    
    override func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * Constants.COLLISION_PERSPECTIVE_ADJUSTMENT, height: size.height * Constants.COLLISION_PERSPECTIVE_ADJUSTMENT))
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.playerBullet.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.mass = 80
    }
    
    //*****************************
    // MARK: - Character
    //*****************************
    
    override func die() {
        super.die()
        action = .dead
    }
    
    func randomAction() -> EnemyAction {
        return .none
    }
    
    func enemyWalk() -> (CGFloat, CGFloat, Double) {
        return (0,0,0)
    }
}
