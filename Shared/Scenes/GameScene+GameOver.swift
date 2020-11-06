//
//  GameScene+ScoreBoard.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 26/6/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

extension GameScene {
    
    
    func showGameOver() {
        let gameOver = placeSpriteNode("game_over", parent: self)
        gameOver.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOver.zPosition = Constants.ZPOS_HUD
        gameOver.alpha = 0
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.4)
        let wait = SKAction.wait(forDuration: 2.0)
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.2)
        let showScoreBoard = SKAction.run { self.showScoreBoard() }
        let remove = SKAction.run { self.removeFromParent() }
        
        gameOver.run(SKAction.sequence([fadeIn,wait,fadeOut,showScoreBoard,remove]))
    }
    
    
    func showScoreBoard() {
        
        // Score Board
        let scoreBoard = placeSpriteNode("reward_box", parent: self)
        scoreBoard.position = CGPoint(x: self.size.width / 2, y: self.size.height + scoreBoard.size.height)
        scoreBoard.scale(to: CGSize(width: 0, height: 0))
        scoreBoard.zPosition = Constants.ZPOS_HUD
        
        // Reward Text
        _ = placeLabelNode("REWARD", fontSize: 72, parent: scoreBoard, position: CGPoint(x: 0, y: 120))
        
        // Medal
        
        func medalForScore() -> String {
            if score >=  Constants.POINTS_FOR_GOLDEN_MEDAL {
                return "gold_medal"
            } else if score >= Constants.POINTS_FOR_SILVER_MEDAL {
                return "silver_medal"
            }
            return "bronze_medal"
        }
        
        let medal = placeSpriteNode(medalForScore(), parent: scoreBoard)
        medal.position = CGPoint(x: 2, y: 50)
        GameCenterHelper.shared.checkForAchievements(userScore: score)
        GameCenterHelper.shared.updateLeaderboard(identifier: Constants.LEADERBOARD_IDENTIFIER, value: score)
        
        // Points
        _ = placeLabelNode(String(score), fontSize: 60, parent: scoreBoard, position: CGPoint(x: 0, y: -20))

        // Menu Button
        _ = placeSpriteNode("menu_box", parent: scoreBoard, position: CGPoint(x: 100, y: -100), name: "menuBtn")
   
        // Play Again Button
        
        let playAgainButton = placeSpriteNode("try_again_box", parent: scoreBoard, position: CGPoint(x: -40, y: -100), name: "playAgainBtn")
        
        _ = placeLabelNode("PLAY AGAIN", fontSize: 40, parent: playAgainButton, name: "playAgainBtn")
        
        // Scoreboard animations
        let move = SKAction.move(to: CGPoint(x: scoreBoard.position.x, y: self.size.height / 2), duration: 1.0)
        move.timingMode = .easeInEaseOut
        let scale = SKAction.scale(to: 1.0, duration: 1.0)
        let moveAndScale = SKAction.group([move,scale])
        
      
        
        let playSound = SKAction.run {
            SoundBox.shared.playMusic(music: "score", numberOfLoops: 0)
        }
        scoreBoard.run(SKAction.sequence([moveAndScale,playSound]))
        
    }
}
