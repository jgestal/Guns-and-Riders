//
//  Money.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Money: Item {
    
    static var baseAnimation : SKAction!
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 60, height: 105)) {

        if Money.baseAnimation == nil {
            Money.baseAnimation = GameSprite.sprites.animate(frames: ["money_1","money_2"], repeatForever: true, duration: 0.2)
        }
        super.spawn(parentNode: parentNode, position: position, size: size)
        run(Money.baseAnimation)
    }
}
