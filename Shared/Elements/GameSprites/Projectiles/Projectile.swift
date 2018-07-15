//
//  Projectile.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Projectile : GameSprite {
    
    var isDissappearing = false
    
    static var horizonDissapearAction : SKAction!
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        super.spawn(parentNode: parentNode, position: position, size: size)
       
        if Projectile.horizonDissapearAction == nil {
            let fade = SKAction.fadeAlpha(by: 0.0, duration: 0.2)
            let scale = SKAction.scale(to: 0.0, duration: 0.15)
            Projectile.horizonDissapearAction = SKAction.group([fade,scale])
        }
    }
    
    override func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
    
    func horizonDissapear() {
        if isDissappearing { return }
        isDissappearing = true
        run(SKAction.sequence([Projectile.horizonDissapearAction, SKAction.run {
            self.removeFromParent()
        }]))
    }
    
    func animate() {
            let wait = SKAction.wait(forDuration: 4.0)
            let fade = SKAction.fadeAlpha(to: 0, duration: 0.2)
            let remove = SKAction.run { self.removeFromParent() }
            run(SKAction.sequence([wait,fade,remove]))
    }
}
