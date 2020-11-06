//
//  GameScene.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 12/1/17.
//  Copyright © 2017 Juan Gestal Romani. All rights reserved.
//

import SpriteKit
#if targetEnvironment(macCatalyst)
import AppKit
#endif
//https://cartoonsmart.com/how-to-support-external-game-controllers-with-swift-2-and-sprite-kit-for-the-new-apple-tv/


class GameScene: SKScene {

    let world = SKNode()
    let hud = HUD()
    let ground = Ground()

    let soundBox = SoundBox.shared
    
    // Add Joystick on iOS Devices
    #if os(iOS) && !targetEnvironment(macCatalyst)
    let joystick = AnalogJoystick(diameters: (110,54), images: (UIImage(named: "joystick_background"), UIImage(named: "joystick_ball")))
    #endif
    
    var backgrounds = [Background]()
    
    let player = Player()
    
    var gameMaxY : CGFloat!
    var gameMinY : CGFloat!
    
    var score = 0
    var indiansKilled = 0
    var badguysKilled = 0
    
    var keyUp = false
    var keyDown = false
    var keyLeft = false
    var keyRight = false
    
    override func didMove(to view: SKView) {
        
        SoundBox.shared.playMusic(music: "game", numberOfLoops: -1)
        
        setupGround()
        
        gameMaxY = ground.position.y + ground.tileHeight - Constants.GROUND_SAFE_AREA_TOP
        gameMinY = ground.position.y + Constants.GROUND_SAFE_AREA_BOTTOM
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        setupJoystick()
        #endif
        
        setupHUD()
        setupBackground()
        setupPhysicsWorld()
        setupPlayer()
        startGameLoop()
        
        addChild(world)

    }
    
    fileprivate func updateSprites() {
        for sprite in world.children {
            if let sprite = sprite as? GameSprite {
                if sprite.position.x + sprite.size.width / 2 < player.position.x - size.width - Constants.PLAYER_OFFSET_X {
                    sprite.removeFromParent()
                } else {
                    sprite.updateZPosition()
                    if let enemy = sprite as? Enemy {
                        if !enemy.isDead {
                            enemy.xScale = enemy.position.x < player.position.x ? -1 : 1
                        }
                    }
                    else if let projectile = sprite as? Projectile {
                        if projectile.position.y - projectile.size.height * 2 > gameMaxY  {
                            projectile.horizonDissapear()
                        }
                    }
                }
            }
        }
    }
    
    override func didSimulatePhysics () {
        
        if !player.isDead {
            
            player.progress = player.position.x - player.initialPositionX
            ground.checkForReposition(playerProgress: player.progress)
            backgrounds.forEach { $0.updatePosition(playerProgress: player.progress) }
            readInput()
            restrictPlayerPosition()
            updateWorld()
        }
        
        player.updatePosition()
        updateSprites()
    }
    
    private func readInput() {
        // Read Input
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        joystick.trackingHandler = { jData in
            if !self.player.isDead {
                let yDisplacement = jData.velocity.y * 0.10 * self.player.vy
                print("Velocity: \(jData.velocity.y)")
                self.player.position.y += yDisplacement
                self.player.xScale = jData.velocity.x < 0 ? -1 : 1
            }
        }
        #elseif targetEnvironment(macCatalyst)
        
        var yDisplacement = CGFloat(0)
        if (keyUp && !keyDown) {
            yDisplacement = 5 * self.player.vy
        } else if (!keyUp && keyDown) {
            yDisplacement = -5 * self.player.vy
        }
        
        player.position.y += yDisplacement
        player.xScale = keyLeft && !keyRight ? -1 : 1

        #endif
    }
    
    private func restrictPlayerPosition() {
        // Bounds
        if player.position.y > self.gameMaxY { player.position.y = self.gameMaxY }
        if player.position.y < self.gameMinY { player.position.y = self.gameMinY }
    }
    
    //*****************************
    // MARK: - Controls
    //*****************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
            
        guard let firstTouch = touches.first else { return }
        
        playerShoot()
        
        if player.isDead {
            let location = firstTouch.location(in: self)
            let nodeTouched = atPoint(location)
            
            if nodeTouched.name == "playAgainBtn" {
                let scene = GameScene(size: size)
                scene.scaleMode = scaleMode
                view?.presentScene(scene)
            }
            else if nodeTouched.name == "menuBtn" {
                let scene = MenuScene(size: size)
                scene.scaleMode = scaleMode
                view?.presentScene(scene)
            }
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {

        for press in presses {
            switch (press.key?.keyCode) {
            
            case .keyboardUpArrow:
                keyUp = true
            case .keyboardDownArrow:
                keyDown = true
            case .keyboardLeftArrow:
                keyLeft = true
            case .keyboardRightArrow:
                keyRight = true
            case .keyboardSpacebar:
                playerShoot()
                
            default:
                break
            }
        }

    }
    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {}
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        cancel(presses)
    }
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        cancel(presses)
    }
    
    private func cancel(_ presses: Set<UIPress>) {
        for press in presses {
            switch (press.key?.keyCode) {
            case .keyboardUpArrow:
                keyUp = false
            case .keyboardDownArrow:
                keyDown = false
            case .keyboardLeftArrow:
                keyLeft = false
            case .keyboardRightArrow:
                keyRight = false
            default:
                break
            }
        }
    }
    
}

//MARK: Update
extension GameScene {
    
    func startGameLoop() {
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run {
                self.spawner()
                self.enemyRandomAction()
            },
            SKAction.wait(forDuration: TimeInterval(1.0))])))
    }
    
    func updateWorld() {
        let worldXPos = -(player.position.x * world.xScale - self.size.width / 2)
        var worldYPos = -(player.position.y * world.yScale - self.size.height / 2)
        worldYPos = worldYPos > 0 ? 0 : worldYPos
        world.setScale(Constants.GAME_SCALE)
        world.position = CGPoint(x: worldXPos, y: worldYPos)
    }
}

extension GameScene {
    
    func incPlayerBullets(_ increment: Int) {
        player.bullets = player.bullets + increment
        if player.bullets > Constants.PLAYER_MAX_BULLETS { player.bullets = Constants.PLAYER_MAX_BULLETS }
        else if player.bullets < 0 { player.bullets = 0 }
        hud.setBullets(newBullets: player.bullets)
    }
    
    func incScore(_ increment: Int) {
        if player.isDead { return }
        score = score + increment
        hud.setScore(newScore: score)
    }
    
    func showText(_ text: String, position: CGPoint) {
        let gameText = GameText()
        gameText.spawn(parentNode: world, position: position, text: text)
    }
}




