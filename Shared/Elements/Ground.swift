//
//  Ground.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 2/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {

    let sprites = SKTextureAtlas(named: "sprites.atlas")

    var tileTexture : SKTexture!
    var jumpWidth : CGFloat!
    var tileWidth : CGFloat!
    var tileHeight : CGFloat!
    var jumpCount = CGFloat(0)
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        
        if tileTexture == nil {
            tileTexture = sprites.textureNamed("ground-tile")
            tileTexture.filteringMode = .nearest
            tileWidth = self.tileTexture.size().width * Constants.GROUND_TEXTURE_ZOOM
            tileHeight = self.tileTexture.size().height * Constants.GROUND_TEXTURE_ZOOM
        }
        createChildrenNodes()
    }
        
    func createChildrenNodes() {
        
        var count = CGFloat(0)
        
        while count * tileWidth * Constants.GAME_SCALE < size.width {
            let tile = SKSpriteNode(texture: tileTexture)
            tile.size = CGSize(width: tileWidth, height: tileHeight)
            tile.position.x = count * tileWidth
            tile.anchorPoint = CGPoint(x: 0, y: 0)
            addChild(tile)
            count += 1
        }
        jumpWidth = tileWidth
    }
    
    func checkForReposition(playerProgress: CGFloat) {
        let groundJumpPosition = jumpWidth * jumpCount
        if playerProgress >= groundJumpPosition {
            self.position.x += jumpWidth
            jumpCount += 1
        }
    }
}
