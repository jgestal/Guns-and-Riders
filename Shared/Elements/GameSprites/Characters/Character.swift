//
//  Actor.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 10/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Character: GameSprite {
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        super.spawn(parentNode: parentNode, position: position, size: size)
        runBaseAction()
    }
    
    func runBaseAction() { }
    func die() {
        removeAllActions()
        physicsBody!.categoryBitMask = 0
        physicsBody!.contactTestBitMask = 0
        physicsBody!.collisionBitMask = 0
    }
}
