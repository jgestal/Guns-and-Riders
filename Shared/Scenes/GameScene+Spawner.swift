//
//  GameScene+Spawner.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 26/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

//*****************************
// MARK: - Spawner
//*****************************

extension GameScene {

    func spawner () {
        
        func randomYPos() -> CGFloat {
            return CGFloat.random(gameMinY, gameMaxY)
        }
        let defaultXPos =  player.position.x + 1000
        
        switch Int.random(0, 10) {
        case 0...2:
            spawnElement(xPos: defaultXPos, yPos: randomYPos())
        case 2...4:
            spawnElement(xPos: defaultXPos, yPos: CGFloat.random(gameMinY, gameMaxY / 2))
            spawnElement(xPos: defaultXPos, yPos: CGFloat.random(gameMaxY / 2 , gameMaxY))
        case 5...7:
            spawnEnemy(xPos: defaultXPos, yPos: randomYPos())
            spawnElement(xPos: defaultXPos, yPos: randomYPos())
        case 8:
            spawnEnemy(xPos: defaultXPos, yPos: randomYPos())
            spawnEnemy(xPos: defaultXPos, yPos: randomYPos())
        default:
            break
        }
    }
    
    func spawnElement(xPos: CGFloat, yPos: CGFloat) {
        switch Int.random(0, 1) {
        case 0:
            let barrel = Barrel()
            barrel.spawn(parentNode: world, position: CGPoint(x: xPos, y: yPos))
        case 1:
            let cactus = Cactus()
            cactus.spawn(parentNode: world, position: CGPoint(x: xPos, y: yPos))
        default:
            break
        }
    }
    
    func spawnEnemy(xPos: CGFloat, yPos: CGFloat) {
        switch Int.random(0, 1) {
        case 0:
            let badguy = BadGuy()
            badguy.spawn(parentNode: world, position: CGPoint(x: xPos, y: yPos))
        case 1:
            let indian = Indian()
            indian.spawn(parentNode: world, position: CGPoint(x: xPos, y: yPos))
        default:
            break
        }
    }
    
    func spawnRandomItem(at position: CGPoint) {
        switch Int.random(0, 4) {
        case 0:
            let boots = Boots()
            boots.spawn(parentNode: world, position: position)
        case 1:
            let bullets = Bullets()
            bullets.spawn(parentNode: world, position: position)
        case 2:
            let money = Money()
            money.spawn(parentNode: world, position: position)
        case 3:
            let pistol = Pistol()
            pistol.spawn(parentNode: world, position: position)
        default:
            break
        }
    }
}

