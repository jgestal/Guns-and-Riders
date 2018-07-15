//
//  Background.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 2/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    
    let nodeSize = CGSize(width: 1050, height: 225)
    var movementMultiplier = CGFloat(0)
    var jumpAdjustment = CGFloat(0)
    
    func spawn(parentNode: SKNode, imageName: String, zPostition: CGFloat, movementMultiplier: CGFloat, yPosition: CGFloat) {
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position = CGPoint(x: 0, y: yPosition)
        self.movementMultiplier = movementMultiplier
        self.zPosition = zPosition
        
        parentNode.addChild(self)
        
        for i in -1...1 {
            
            let node = SKSpriteNode(imageNamed: imageName)
            node.texture?.filteringMode = .nearest
            node.size = nodeSize
            node.anchorPoint = CGPoint(x: 0, y: 0)
            node.position = CGPoint(x: CGFloat(i) * nodeSize.width, y: 0)
            self.addChild(node)
            
        }
    }
    
    func updatePosition(playerProgress: CGFloat) {
        
     let adjustedPosition = jumpAdjustment + playerProgress * (1 - movementMultiplier)
        
        if playerProgress - adjustedPosition > nodeSize.width {
            jumpAdjustment += nodeSize.width
        }

        self.position.x = adjustedPosition
    }
}
