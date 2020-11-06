//
//  CreditsScene.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 16/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

enum NodeLevel :CGFloat {
    case board = 10, moving = 100, enlarged = 200
}

class CreditsScane: SKScene {
    
    var object : SKSpriteNode!
    var fourAcesTrick = false
    
    let table = SKNode()
    
    var cardsBackground = CardsBackground()
    
    var cards = [Card]()
    
    var firstTimeFourAcesTrick = true
    
    override func didMove(to view: SKView) {
    
        SoundBox.shared.playMusic(music: "credits", numberOfLoops: -1)
        
        cardsBackground.spawn(parentNode: self, position: CGPoint(x: 0, y: 0), size: self.size)
        addChild(table)
        
        let posterJimmy = Poster(posterType: .jimmy)
        posterJimmy.position = CGPoint(x: size.width / 6, y: size.height / 1.5)
        table.addChild(posterJimmy)
        
        let posterKanfor = Poster(posterType: .kanfor)
        posterKanfor.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        table.addChild(posterKanfor)
        
        let eightOfTrebols = Card(cardType: .eigthOfTrebols)
        eightOfTrebols.position = CGPoint(x: size.width / 6, y: 60)
        table.addChild(eightOfTrebols)
        cards.append(eightOfTrebols)
        
        let eightOfClubs = Card(cardType: .eightOfClubs)
        eightOfClubs.position = CGPoint(x: (size.width / 6) + 80, y: 60)
        table.addChild(eightOfClubs)
        cards.append(eightOfClubs)
        
        let aceOfClubs = Card(cardType: .aceOfClubs)
        aceOfClubs.position = CGPoint(x: (size.width / 6) + 160, y: 60)
        table.addChild(aceOfClubs)
        cards.append(aceOfClubs)
        
        let aceOfTrebols = Card(cardType: .aceOfTrebols)
        aceOfTrebols.position = CGPoint(x: (size.width / 6) + 240, y: 60)
        table.addChild(aceOfTrebols)
        cards.append(aceOfTrebols)
        
        // Menu Button
        let menuBox = placeSpriteNode("menu_box", parent: self, name: "menu")
        menuBox.position = CGPoint(x: self.size.width - menuBox.size.width / 2 - 10, y: self.size.height - menuBox.size.height / 2 - 10)
                        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touch = touches.first
            else { return }
        
        let location = touch.location(in: self)
        
        let nodeTouched = atPoint(location)
        
        if nodeTouched.name == "menu" {
            SoundBox.shared.stopMusic()
            let scene = MenuScene(size: size)
            scene.scaleMode = scaleMode
            view?.presentScene(scene)
            print("Menu")
        } else if object == nil {
            if let card = nodeTouched as? Card {
                if touch.tapCount > 1 {
                    card.flip()
                    checkIfFourAces()
                    run(SoundBox.shared.fxFlap)
                }
                object = card
            }
            else if let poster = nodeTouched as? Poster {
                object = poster
            }
            
            let rotR = SKAction.rotate(byAngle: 0.15, duration: 0.2)
            let rotL = SKAction.rotate(byAngle: -0.15, duration: 0.2)
            let cycle = SKAction.sequence([rotR, rotL, rotL, rotR])
            let wiggle = SKAction.repeatForever(cycle)
            
            object?.zPosition = NodeLevel.moving.rawValue
            object?.removeAction(forKey: "drop")
            object?.run(SKAction.scale(to: 1.3, duration: 0.25), withKey: "pickup")
            object?.run(wiggle, withKey: "wiggle")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let object = object {
            object.zPosition = NodeLevel.board.rawValue
            object.removeFromParent()
            addChild(object)
            object.removeAction(forKey: "pickup")
            object.removeAction(forKey: "wiggle")
            object.run(SKAction.rotate(toAngle: 0, duration: 0.2))
            object.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
        }
        object = nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        object?.position = location
    }
    
    func checkIfFourAces() {
        
        if firstTimeFourAcesTrick && cards.reduce(true, { $0 && $1.isAce() }) {
            run(SoundBox.shared.fxCheat)
            firstTimeFourAcesTrick = false
        }
    }
}

