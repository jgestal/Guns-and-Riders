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
    
    var removeAdsBox : SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(CreditsScane.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)

        // Disable Trick
        //UserDefaults.standard.setValue(false, forKey: "fourAcesTrick")
        
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
        
        if !IAPHelper.shared.isAdsEnabled() {
            eightOfClubs.changeToAce()
            eightOfTrebols.changeToAce()
        }
        
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
        
        // Remove Ads Button
        removeAdsBox = placeSpriteNode("remove_ads_box", parent: self, name: "removeAds")
        removeAdsBox.position = CGPoint(x: self.size.width - removeAdsBox.size.width / 2 - 10, y: 100)
        
        // Remove Ads
        let removeAds = placeLabelNode("REMOVE ADS", fontSize: 26, parent: removeAdsBox, name: "removeAds")
        removeAds.position = CGPoint(x: 0, y: 40)
        
        // The Most Wanted
        let theMostWanted = placeSpriteNode("the_most_wanted", parent: removeAdsBox, name: "removeAds")
        theMostWanted.setScale(0.25)
        theMostWanted.position = CGPoint(x: 0, y: -10)
        
        // Restore Purchases
        let restorePurchases = placeLabelNode("Restore Purchase", fontSize: 16, parent: removeAdsBox, name: "restorePurchase")
        restorePurchases.position = CGPoint(x: 0, y: -80)
        
        showOrHideRemoveAdsBox()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touch = touches.first
            else { return }
        
        let location = touch.location(in: self)
        
        let nodeTouched = atPoint(location)
        
        if nodeTouched.name == "menu" {
            SoundBox.shared.stopMusic()
            view?.presentScene(MenuScene(size:size))
            print("Menu")
        } else if nodeTouched.name == "removeAds" {
            print("Remove Ads")
            IAPHelper.shared.buyProductWithID("guns.and.riders_remove.ads")
        } else if nodeTouched.name == "restorePurchase" {
            print("Restore Purchase")
            IAPHelper.shared.restorePurchases()
            
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
        if IAPHelper.shared.isRemoveAdsPurchased() { return }
        let fourAces = cards.reduce(true, { $0 && $1.isAce() })
        if fourAces {
            // first trick
            let trickEnabled = UserDefaults.standard.bool(forKey: "fourAcesTrick")
            if !trickEnabled  {
                print("First 4 Aces Trick")
                run(SoundBox.shared.fxCheat)
                UserDefaults.standard.setValue(true, forKey: "fourAcesTrick")
                showOrHideRemoveAdsBox()
            }
        }
    }
    
    func showOrHideRemoveAdsBox() {
        removeAdsBox.isHidden = !IAPHelper.shared.isAdsEnabled() || !IAPHelper.canMakePayments()
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        if productID == IAPHelper.removeAdsProductID {
            cards.forEach { $0.changeToAce() }
            showOrHideRemoveAdsBox()
        }
    }
}

