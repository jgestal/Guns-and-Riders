//
//  BadGuyBullet.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class BadGuyBullet: Projectile {
    
    static var baseAnimation: SKAction!

    var bullet = GameSprite()
    var shadow = GameSprite()
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 4, height: 4)) {
        
        if BadGuyBullet.baseAnimation == nil {
            BadGuyBullet.baseAnimation = GameSprite.sprites.animate(frames: ["cowboy_bullet_1","cowboy_bullet_2"], repeatForever: true, duration: 0.1)
        }

        super.spawn(parentNode: parentNode, position: position, size: size)
        
        bullet.spawn(parentNode: self, position: CGPoint(x: 0, y: 0), size: size)
        bullet.run(BadGuyBullet.baseAnimation)
        
        shadow.texture = GameSprite.sprites.textureNamed("bullet_shadow")
        shadow.spawn(parentNode: self, position: CGPoint(x: 0, y: Constants.PROJECTILE_SHADOW_ADJUSTMENT), size: size)
    }
    
    override func setupPhysicsBody() {
        super.setupPhysicsBody()
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemyBullet.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    }
}
