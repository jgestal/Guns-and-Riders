//
//  Boots.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 12/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class Boots: Item {
    
    static var baseAnimation : SKAction!
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 40, height: 36)) {
        
        if Boots.baseAnimation == nil {
            Boots.baseAnimation = GameSprite.sprites.animate(frames: ["boots_1","boots_2"], repeatForever: true, duration: 0.2)
        }
        super.spawn(parentNode: parentNode, position: position, size: size)
        run(Boots.baseAnimation)
    }
}
