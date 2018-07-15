//
//  Item.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 12/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Item: GameSprite {

    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 0, height: 0)) {
        super.spawn(parentNode: parentNode, position: position, size: size)
    }
    
    override func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width / 2, height: size.height / 2))
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.item.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
        physicsBody?.collisionBitMask = 0
    }
}
