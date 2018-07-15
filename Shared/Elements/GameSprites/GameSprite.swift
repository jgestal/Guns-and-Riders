//
//  GameSprite.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 2/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//


import SpriteKit

class GameSprite: SKSpriteNode {

    static var sprites: SKTextureAtlas = SKTextureAtlas.init(named: "sprites.atlas")

    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        self.size = size
        self.position = position
        setupPhysicsBody()
        parentNode.addChild(self)
    }
    
    func updateZPosition () {
        zPosition = Constants.ZPOS_GAME_SPRITE - position.y + size.height / 2
    }
    func setupPhysicsBody() { }
}
