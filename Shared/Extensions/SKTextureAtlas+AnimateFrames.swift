//
//  SKA.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

extension SKTextureAtlas {
    func animate(frames: [String], repeatForever: Bool, duration: TimeInterval) -> SKAction {
        var textures = [SKTexture]()
        
        for frame in frames {
            let texture = self.textureNamed(frame)
            texture.filteringMode = .nearest
            textures.append(texture)
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: duration)
        
        if repeatForever {
            return SKAction.repeatForever(animation)
        } else {
            return animation
        }
    }
}
