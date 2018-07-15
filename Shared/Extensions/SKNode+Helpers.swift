//
//  SKNode+Helpers.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 27/6/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func placeSpriteNode(_ textureNamed: String,
                         parent: SKNode,
                         position: CGPoint? = CGPoint(x: 0, y: 0),
                         name: String? = "",
                         zoom: CGFloat = Constants.TEXTURE_ZOOM) -> SKSpriteNode {
        
        let spriteNode = SKSpriteNode(texture: Constants.SPRITES_ATLAS.textureNamed(textureNamed))
        spriteNode.texture?.filteringMode = .nearest
        spriteNode.size = spriteNode.size * zoom
        spriteNode.name = name
        spriteNode.position = position!
        parent.addChild(spriteNode)
        return spriteNode
    }
    
    func placeLabelNode(_ text: String,
                        fontSize: CGFloat,
                        parent: SKNode,
                        position: CGPoint? = CGPoint(x:0, y:0),
                        name: String? = "") -> SKLabelNode {
        
        let labelNode = SKLabelNode(text: text)
        labelNode.fontName = Constants.FONT_NAME
        labelNode.fontSize = fontSize
        labelNode.verticalAlignmentMode = .center
        labelNode.name = name
        labelNode.position = position!
        parent.addChild(labelNode)
        return labelNode
    }
}

