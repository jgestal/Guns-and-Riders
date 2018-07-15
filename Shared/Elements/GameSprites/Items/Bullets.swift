//
//  Bullets.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Bullets: Item {
    
    static var baseAnimation : SKAction!

    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 40, height: 40)) {

        if Bullets.baseAnimation == nil {
            Bullets.baseAnimation = GameSprite.sprites.animate(frames: ["bullets_1","bullets_2"], repeatForever: true, duration: 0.2)
        }
        super.spawn(parentNode: parentNode, position: position, size: size)
        run(Bullets.baseAnimation)
    }
}
