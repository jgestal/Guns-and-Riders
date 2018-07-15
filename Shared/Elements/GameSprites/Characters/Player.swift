//
//  Player.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 2/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class Player: Character {
    
    static var baseAnimation: SKAction!
    static var injuryAnimation: SKAction!
    
    var initialPositionX : CGFloat!
    var isDead = false
    
    var pistolLevel = 0
    var bootsLevel = 0
    var bullets = Constants.PLAYER_INITIAL_BULLETS
    
    var progress = CGFloat(0)
    
    var vy : CGFloat {
        return 1.0 + 1.0 * CGFloat(bootsLevel) / 3
    }
    
    override func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 45, height: 80)) {
        
        if Player.baseAnimation == nil {
            Player.baseAnimation = GameSprite.sprites.animate(frames: ["cowboy_walk","cowboy_stand"], repeatForever: true, duration: 0.2)
        }
        
        if Player.injuryAnimation == nil {
            Player.injuryAnimation = GameSprite.sprites.animate(frames:  ["cowboy_injuried_1", "cowboy_injuried_2"], repeatForever: false, duration: 0.5)
        }
        
        initialPositionX = position.x
        super.spawn(parentNode: parentNode, position: position, size: size)
    }
    
    override func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width / 3, height: size.height * Constants.COLLISION_PERSPECTIVE_ADJUSTMENT))
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        physicsBody?.contactTestBitMask = 0
        physicsBody?.collisionBitMask = 0
    }

    override func runBaseAction() {
        run(Player.baseAnimation)
    }
    
    override func die() {
        super.die()
        isDead = true
    
        let injury = Player.injuryAnimation
        let texture = SKAction.setTexture(GameSprite.sprites.textureNamed("cowboy_dead"))
        let rotate = SKAction.rotate(byAngle: xScale * 4.71239, duration: 0)
        let blink = SKAction.blink(repetitions: 4)
        let removeFromParent = SKAction.run { self.removeFromParent() }
      
        let textureRotate = SKAction.group([texture,rotate, SKAction.run {
             self.anchorPoint = CGPoint(x: 0, y: 0)
        }])
        
        let sequence = SKAction.sequence([injury!,textureRotate,blink,removeFromParent])
        run(sequence)
    }
    
    func updatePosition() {
        self.physicsBody?.velocity = isDead ? CGVector(dx: 0, dy: 0) : CGVector(dx: Constants.PLAYER_VX, dy: vy)
    }
    
    func powerUpBoots() {
        bootsLevel = bootsLevel > 3 ? 3 : bootsLevel + 1
    }
    
    func powerDownBoots() {
        bootsLevel = bootsLevel <= 0 ? 0 : bootsLevel - 1
    }
    
    func powerUpPistol() {
        pistolLevel = pistolLevel > 2 ? 2 : pistolLevel + 1
    }
    
    func powerDownPistol() {
        pistolLevel = pistolLevel <= 0 ? 0 : pistolLevel - 1
    }
}
