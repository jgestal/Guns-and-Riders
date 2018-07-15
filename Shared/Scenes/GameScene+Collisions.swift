//
//  GameScene+SKPhysicsContactDelegate.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

enum PhysicsCategory: UInt32 {
    case player = 1
    case item = 2
    case enemy = 4
    case playerBullet = 8
    case enemyBullet = 16
    case barrel = 32
    case cactus = 64
    case none = 128
}

extension GameScene: SKPhysicsContactDelegate {
    
    func collision(ofPlayerBullet playerBullet: PlayerBullet, withEnemy enemy: Enemy) {
        var points : Int?
        
        enemy.isDead = true 
        
        if enemy is Indian {
            points = Constants.INDIAN_POINTS
            indiansKilled += 1
        }
            
        else if enemy is BadGuy {
            points = Constants.BAD_GUY_POINTS
            badguysKilled += 1
        }
        
        showText(String(points!), position: enemy.position)
        enemy.die()
        playerBullet.removeFromParent()
        
        run(soundBox.fxPoints)
        incScore(points!)
    }
    
    func collision(ofProjectile projectile: Projectile, withBarrel barrel: Barrel) {
        barrel.removeFromParent()
        
        projectile.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),
                                          SKAction.run { projectile.removeFromParent() }]))
        spawnRandomItem(at: barrel.position)
        run(soundBox.fxBarrel)
    }
    
    func collision(ofProjectile projectile: Projectile, withCactus cactus: Cactus) {
        projectile.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.2),
                                          SKAction.run { projectile.removeFromParent() }]))
        
    }
    
    func collision(ofEnemyBullet enemyBullet: Projectile, withPlayer player: Player) {
        enemyBullet.removeFromParent()
        
        let textList = ["ARGH!","OUCH!","NOO!","BYE", "R.I.P.", "DEAD!"]
        let randomElement = Int.random(0, textList.count - 1)
        showText(textList[randomElement], position: player.position)
        player.die()
        run(SoundBox.shared.fxDead)
        SoundBox.shared.playMusic(music: "gameover", numberOfLoops: 0)
        #if os(iOS)
        let fade = SKAction.fadeAlpha(to: 0, duration: 0.2)
        let remove = SKAction.run {
            self.joystick.removeFromParent()
        }
        let sequence = SKAction.sequence([fade,remove])
        joystick.run(sequence)
        #endif

        run(SKAction.sequence([SKAction.wait(forDuration: 3.0),SKAction.run { self.showGameOver() }]))
        
    }

    func collision(ofPlayer player: Player, withItem item: Item) {
        run(soundBox.fxItem)
        
        if item is Boots {
            player.powerUpBoots()
            showText("+ SPEED", position: player.position)

            player.removeAction(forKey: "powerDownBoots")
            
            let wait = SKAction.wait(forDuration: Constants.POWER_UP_TIME_INTERVAL)
            let powerDown = SKAction.run {
                player.powerDownBoots()
                self.showText("- SPEED", position: self.player.position)
                player.run(SoundBox.shared.fxPowerDown)
            }
            player.run(SKAction.sequence([wait,powerDown]), withKey: "powerDownBoots")
        }
            
        else if item is Bullets {
            showText("+ \(Constants.ITEM_BULLETS_NUMBER)", position: player.position)
            incPlayerBullets(Constants.ITEM_BULLETS_NUMBER)
        }
            
        else if item is Money {
            showText("\(Constants.POINTS_MONEY_BAG)", position: player.position)
            incScore(Constants.POINTS_MONEY_BAG)
        }
            
        else if item is Pistol {
            player.powerUpPistol()
            showText("+ PISTOL", position: player.position)
            player.removeAction(forKey: "powerDownPistol")
            let wait = SKAction.wait(forDuration: Constants.POWER_UP_TIME_INTERVAL)
            let powerDown = SKAction.run {
                player.powerDownPistol()
                self.showText("- PISTOL", position: self.player.position)
                self.run(SoundBox.shared.fxPowerDown)
            }
            player.run(SKAction.sequence([wait, powerDown]), withKey: "powerDownPistol")
        }
        item.removeFromParent()
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {

        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        switch contactMask {
            
        // Player Bullet <-> Enemy
        case PhysicsCategory.enemy.rawValue | PhysicsCategory.playerBullet.rawValue:
            let enemy = contact.bodyA.categoryBitMask == PhysicsCategory.enemy.rawValue ? contact.bodyA.node : contact.bodyB.node
            let playerBullet = contact.bodyA.categoryBitMask == PhysicsCategory.playerBullet.rawValue ? contact.bodyA.node : contact.bodyB.node
            collision(ofPlayerBullet: playerBullet as! PlayerBullet, withEnemy: enemy as! Enemy)
            
        // Player Bullet <-> Barrel
        // Enemy Bullet <-> Barrel
        case PhysicsCategory.playerBullet.rawValue | PhysicsCategory.barrel.rawValue,
             PhysicsCategory.enemyBullet.rawValue | PhysicsCategory.barrel.rawValue:

            let barrel =  contact.bodyA.categoryBitMask == PhysicsCategory.barrel.rawValue ? contact.bodyA.node : contact.bodyB.node
            let projectile = contact.bodyA.categoryBitMask == PhysicsCategory.playerBullet.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            collision(ofProjectile: projectile as! Projectile, withBarrel: barrel as! Barrel)
       
        // Player Bullet <-> Cactus
        // Enemy Bullet <-> Cactus
        case PhysicsCategory.playerBullet.rawValue | PhysicsCategory.cactus.rawValue,
             PhysicsCategory.enemyBullet.rawValue | PhysicsCategory.cactus.rawValue:

            let cactus = contact.bodyA.categoryBitMask == PhysicsCategory.cactus.rawValue ? contact.bodyA.node : contact.bodyB.node
            let projectile = contact.bodyA.categoryBitMask == PhysicsCategory.playerBullet.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            collision(ofProjectile: projectile as! Projectile, withCactus: cactus as! Cactus)
         
        // Player <-> Item
        case PhysicsCategory.player.rawValue | PhysicsCategory.item.rawValue:
            
            let player = contact.bodyA.categoryBitMask == PhysicsCategory.player.rawValue ? contact.bodyA.node : contact.bodyB.node
            let item = contact.bodyA.categoryBitMask == PhysicsCategory.item.rawValue ? contact.bodyA.node : contact.bodyB.node

            collision(ofPlayer: player as! Player, withItem: item as! Item)
        
            
        // Enemy Bullet <-> Player
        case PhysicsCategory.enemyBullet.rawValue | PhysicsCategory.player.rawValue:
            
            let player = contact.bodyA.categoryBitMask == PhysicsCategory.player.rawValue ? contact.bodyA.node : contact.bodyB.node
            let enemyBullet = contact.bodyA.categoryBitMask == PhysicsCategory.enemyBullet.rawValue ? contact.bodyA.node : contact.bodyB.node
        
            collision(ofEnemyBullet: enemyBullet as! Projectile, withPlayer: player as! Player)
            
        default:
            print("Collision not implemented: \(contact.bodyA) \(contact.bodyB)")
            break
        }
    }
}
