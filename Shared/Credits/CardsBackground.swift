//
//  CardsBackground.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 16/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class CardsBackground: SKSpriteNode {


    var tileTexture : SKTexture!
    var tileWidth : CGFloat!
    var tileHeight : CGFloat!

    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {        
        parentNode.addChild(self)
        self.size = size
        self.position = position
        
        if tileTexture == nil {
            tileTexture = Constants.SPRITES_ATLAS.textureNamed("cards_background")
            tileTexture.filteringMode = .nearest
            tileWidth = self.tileTexture.size().width * Constants.GROUND_TEXTURE_ZOOM
            tileHeight = self.tileTexture.size().height * Constants.GROUND_TEXTURE_ZOOM
        }
        createChildrenNodes()
    }
    
    func createChildrenNodes() {
        
        var countX = CGFloat(0)
        var countY = CGFloat(0)
        
        while countX * tileWidth < self.size.width {
            while countY * tileHeight < self.size.height {
            
                let tile = SKSpriteNode(texture: tileTexture)
                tile.size = CGSize(width: tileWidth, height: tileHeight)
                tile.position.x = countX * tileWidth
                tile.position.y = countY * tileHeight
                tile.anchorPoint = CGPoint(x: 0, y: 0)
                addChild(tile)
                
                countY += 1
            }
            countX += 1
        }
    }
}
