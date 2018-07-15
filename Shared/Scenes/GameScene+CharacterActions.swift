//
//  GameScene+CharacterActions.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

//*****************************
// MARK: - Player
//*****************************

extension GameScene {
    
    func playerShoot() {
        
        func shootTo(dy: CGFloat) {
            let vector = CGVector.normalized(from: player.position, to: CGPoint(x: player.position.x + player.xScale, y: player.position.y + dy))
            let bullet = PlayerBullet()
            bullet.spawn(parentNode: world, position: player.position)
            bullet.physicsBody?.applyImpulse(vector * Constants.BULLET_IMPULSE)
            bullet.animate()
        }
        if player.bullets > 0 {
            shootTo(dy: 0)
            if player.pistolLevel > 0 { shootTo(dy: 0.3 * player.xScale) }
            if player.pistolLevel > 1 { shootTo(dy: -0.3 * player.xScale) }
            incPlayerBullets(-1)
            run(soundBox.fxShoot)
        }
        else {
            run(soundBox.fxNoBullets)
        }
    }
}

//*****************************
// MARK: - Enemies
//*****************************

extension GameScene {
    
    func enemyRandomAction() {
        world.children.filter { $0 is Enemy }.forEach { enemy in
            if let enemy = enemy as? Enemy {
                switch(enemy.randomAction()) {
                case .walk:
                    enemyActionWalk(enemy)
                case .shoot:
                    enemyActionShoot(enemy)
                default:
                    enemyActionWait(enemy)
                    break
                }
            }
        }
    }
    
    func enemyActionWait(_ enemy: Enemy) {
        enemy.action = .wait
        let duration = Double.random(0.5, 2.0)
        let wait = SKAction.wait(forDuration: duration)
        let restore = SKAction.run { enemy.action = .none }
        enemy.run(SKAction.sequence([wait, restore]))
    }
    
    func enemyActionWalk(_ enemy: Enemy) {
        if enemy.isDead { return }
        
        let walkBehavior = enemy.enemyWalk()
        
        let dx = walkBehavior.0
        var dy = walkBehavior.1
        let duration = walkBehavior.2
        
        enemy.action = .walk
        

        if dy + enemy.position.y + enemy.size.height / 2 >= gameMaxY {
            dy = gameMaxY - enemy.position.y - enemy.size.height / 2
        }
        else if dy + enemy.position.y - enemy.size.height / 2 <= gameMinY {
            dy = gameMinY - enemy.position.y + enemy.size.height / 2
        }
        
        let move = SKAction.move(by: CGVector(dx: dx, dy: dy), duration: duration)
        let restore = SKAction.run { enemy.action = .none }
        enemy.run(SKAction.sequence([move,restore]))
    }
    
    func enemyActionShoot(_ enemy: Enemy) {
        if enemy.isDead || player.isDead { return }
        
        enemy.action = .shoot
        let vector = CGVector.normalized(from: enemy.position, to: player.position)
        
        if let _ = enemy as? BadGuy {
            let bullet = BadGuyBullet()
            bullet.spawn(parentNode: world, position: enemy.position)
            bullet.physicsBody!.applyImpulse(vector * Constants.BULLET_IMPULSE)
            bullet.animate()
            run(soundBox.fxShoot)
        }
        else if let indian = enemy as? Indian {
            let indianKnife = IndianKnife()
            indianKnife.spawn(parentNode: world, position: indian.position)
            indianKnife.physicsBody?.applyImpulse(vector * Constants.KNIFE_IMPULSE)
            indian.throwKnife()
            indianKnife.animate()
            run(soundBox.fxKnife)
        }
        let wait = SKAction.wait(forDuration: 0.5)
        let restore = SKAction.run { enemy.action = .none }
        enemy.run(SKAction.sequence([wait,restore]))
    }
}

