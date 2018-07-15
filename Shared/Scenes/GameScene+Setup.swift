//
//  GameScene+Setup.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 22/6/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    func setupHUD() {
        hud.setup(screenSize: self.size)
        self.addChild(hud)
        hud.zPosition = Constants.ZPOS_HUD
        hud.setBullets(newBullets: player.bullets)
    }
    
    func setupGround() {
        let position = CGPoint(x: -self.size.width, y: 0)
        let size = CGSize(width: self.size.width * 3, height: 0)
        ground.spawn(parentNode: world, position: position, size: size)
    }
    
    #if os(iOS)
    func setupJoystick() {
        joystick.zPosition = Constants.ZPOS_JOYSTICK
        joystick.position = CGPoint(x: 70, y: 80)
        addChild(joystick)
    }
    #endif
    
    func setupBackground() {
        
        self.backgroundColor = UIColor(red:0.54, green:0.69, blue:0.77, alpha:1.0)
        let images = ["cactus_background","mountains_background","clouds_background"]
        let movementMultipliers : [CGFloat] = [0.50, 0.15, 0.10]
        let yPosition = ground.position.y + ground.tileHeight
        
        for i in 0...2 {
            let background = Background()
            background.spawn(parentNode: world, imageName: images[i], zPostition: zPosition, movementMultiplier: movementMultipliers[i], yPosition: yPosition)
            backgrounds.append(background)
        }
    }
    
    func setupPlayer() {
        let initialPlayerPosition = CGPoint(x: Constants.PLAYER_OFFSET_X, y: (gameMaxY + gameMinY) / 2)
        player.spawn(parentNode: world, position: initialPlayerPosition)
    }
    
    func setupPhysicsWorld () {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
}
