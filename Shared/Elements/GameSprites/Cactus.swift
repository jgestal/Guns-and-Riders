//
//  Cactus.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 12/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Cactus: GameSprite {
    
    func spawn(parentNode: SKNode, position: CGPoint) {
        
        var cactusSize : CGSize!
        var cactusTexture : SKTexture!
        
        if arc4random_uniform(2) == 0 {
            cactusSize = CGSize(width: 48, height: 50)
            cactusTexture = GameSprite.sprites.textureNamed("cactus_1")
        } else {
            cactusSize = CGSize(width: 50, height: 62)
            cactusTexture = GameSprite.sprites.textureNamed("cactus_2")
        }
        cactusTexture!.filteringMode = .nearest
        texture = cactusTexture
        super.spawn(parentNode: parentNode, position: position, size: cactusSize)
    }
    
    override func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * Constants.COLLISION_PERSPECTIVE_ADJUSTMENT, height: size.height * Constants.COLLISION_PERSPECTIVE_ADJUSTMENT))
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.cactus.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.playerBullet.rawValue | PhysicsCategory.enemyBullet.rawValue
        self.physicsBody!.collisionBitMask = 0
    }
}

