//
//  Card.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 24/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

enum CardType: Int {
    case eightOfClubs, eigthOfTrebols, aceOfClubs, aceOfTrebols, aceOfHearts, aceOfDiamonds
}



class Card: SKSpriteNode {
    var cardType : CardType
    var frontTexture : SKTexture
    let backTexture : SKTexture
    var faceUp = true
    var canFlip = true
    
    var flipCounter = 0
    
    init(cardType: CardType) {
        
        self.cardType = cardType
        backTexture = Constants.SPRITES_ATLAS.textureNamed("card_back")
        backTexture.filteringMode = .nearest
        
        switch cardType {
        case .eightOfClubs:
            frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_8_clubs")
        case .eigthOfTrebols:
            frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_8_trebols")
        case .aceOfClubs:
            frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_ace_clubs")
        case .aceOfTrebols:
            frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_ace_trebols")
        case .aceOfHearts:
            frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_ace_hearts")
        case .aceOfDiamonds:
            frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_ace_diamonds")
        }
        
        frontTexture.filteringMode = .nearest
        
        let size = CGSize(width: frontTexture.size().width, height: frontTexture.size().height)
        
        super.init(texture: frontTexture, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeToAce() {
        if cardType == .eightOfClubs {
            cardType = .aceOfHearts
            frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_ace_hearts")
        }
        else if cardType == .eigthOfTrebols {
            cardType = .aceOfDiamonds
            frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_ace_diamonds")
        }
        if faceUp {
            texture = frontTexture
        }
    }
    
    func flip() {
        
        if (canFlip) {
            flipCounter = flipCounter + 1
            let firstHalfFlip = SKAction.scaleX(to: 0.0, duration: 0.4)
            let secondHalfFlip = SKAction.scaleX(to: 1.0, duration: 0.4)
            setScale(1.0)
            canFlip = false
            if faceUp {
                run(firstHalfFlip) {
                    self.texture = self.backTexture
                    self.run(secondHalfFlip) {
                        self.canFlip = true
                    }
                }
            } else {
                if flipCounter > 4 {
                    if cardType == .eightOfClubs {
                        cardType = .aceOfHearts
                        frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_ace_hearts")
                    }
                    else if cardType == .eigthOfTrebols {
                        cardType = .aceOfDiamonds
                        frontTexture = Constants.SPRITES_ATLAS.textureNamed("card_ace_diamonds")
                    }
                }
                run(firstHalfFlip) {
                    self.texture = self.frontTexture
                    self.run(secondHalfFlip) {
                        self.canFlip = true
                    }
                }
            }
            faceUp = !faceUp
        }
    }
    
    func isAce () -> Bool {
        return cardType.rawValue > 1
    }
}

