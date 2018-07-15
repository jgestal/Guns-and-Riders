//
//  IndianKnife.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class IndianKnife : Projectile {
    
    static var baseAnimation : SKAction!
    static var dissapearAnimation : SKAction!
    
    var knife = GameSprite()
    var shadow = GameSprite()
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 15, height: 25)) {

        if IndianKnife.baseAnimation == nil {
            let knifeAnimation = GameSprite.sprites.animate(frames: ["knife_1","knife_2"], repeatForever: false, duration: 0.1)
            let knifeRotation = SKAction.rotate(byAngle: 2.0, duration: 0.1)
            IndianKnife.baseAnimation = SKAction.repeatForever(SKAction.group([knifeAnimation,knifeRotation]))
        }
        
        if IndianKnife.dissapearAnimation == nil {
            let movement = SKAction.move(by: CGVector(dx: 0, dy: Constants.PROJECTILE_SHADOW_ADJUSTMENT), duration: 0.5)
            let fade = SKAction.fadeAlpha(to: 0, duration: 0.5)
            let dissappear = SKAction.removeFromParent()
            IndianKnife.dissapearAnimation = SKAction.sequence([movement,SKAction.group([fade,dissappear])])
        }
        
        super.spawn(parentNode: parentNode, position: position, size: size)
        
        knife.spawn(parentNode: self, position: CGPoint(x: 0, y: 0), size: self.size)
        shadow.texture = GameSprite.sprites.textureNamed("knife_shadow")
        shadow.spawn(parentNode: self, position: CGPoint(x: 0, y: Constants.PROJECTILE_SHADOW_ADJUSTMENT), size:  CGSize(width: 20, height: 5))
    }
    
    override func setupPhysicsBody() {
        super.setupPhysicsBody()
        
        physicsBody?.categoryBitMask = PhysicsCategory.enemyBullet.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue | PhysicsCategory.cactus.rawValue
    }
    
    override func updateZPosition() {
        super.updateZPosition()
//        knife.zPosition = -1 * (knife.position.y - knife.size.height / 2) + 1000
//        shadow.zPosition = -1 * (shadow.position.y - shadow.size.height / 2) * 1000
    }
    
    override func animate() {
        knife.run(IndianKnife.baseAnimation)
        let wait = SKAction.wait(forDuration: 2.0)
        let disablePhysics = SKAction.run {
            self.physicsBody = nil
        }
//        let fall = SKAction.move(to: shadow.position, duration: 0.2)
        let fall = SKAction.move(by: CGVector(dx: 0, dy: Constants.PROJECTILE_SHADOW_ADJUSTMENT), duration: 0.2)
        let fade = SKAction.fadeAlpha(to: 0, duration: 0.2)
        let fallAndFade = SKAction.group([fall,fade])
        let remove = SKAction.run {
            self.removeFromParent()
        }
        knife.run(SKAction.sequence([wait,disablePhysics,fallAndFade,remove]))
    }
}
