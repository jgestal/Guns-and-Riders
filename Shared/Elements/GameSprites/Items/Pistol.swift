//
//  Pistol.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Pistol: Item {
    
    static var baseAnimation : SKAction!
    
    override func spawn(parentNode: SKNode, position: CGPoint,  size: CGSize = CGSize(width: 55, height: 50)) {
        if Pistol.baseAnimation == nil {
            Pistol.baseAnimation = GameSprite.sprites.animate(frames: ["pistol_1","pistol_2"], repeatForever: true, duration: 0.2)
        }
        super.spawn(parentNode: parentNode, position: position, size: size)
        run(Pistol.baseAnimation)
    }
}
