//
//  Barrel.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 12/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class Barrel: GameSprite {
    
    override func spawn(parentNode: SKNode, position: CGPoint,  size: CGSize = CGSize(width: 50, height: 60)) {
         super.spawn(parentNode: parentNode, position: position, size: size)
         self.texture = GameSprite.sprites.textureNamed("barrel")
         self.texture?.filteringMode = .nearest
    }

    override func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * Constants.COLLISION_PERSPECTIVE_ADJUSTMENT, height: size.height * Constants.COLLISION_PERSPECTIVE_ADJUSTMENT))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.barrel.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.playerBullet.rawValue | PhysicsCategory.enemyBullet.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
}
