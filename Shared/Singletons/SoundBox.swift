//
//  SoundBox.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 14/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit
import AVFoundation

class SoundBox {
    static let shared = SoundBox()
    
    var audioPlayers = [String:AVAudioPlayer]()
    let music = ["gameover","game","menu","credits","score"]
    
    func preloadMusic() {
        music.forEach { music in
            var player : AVAudioPlayer?
            do {
                player = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: music, withExtension: "mp3")!)
                if let player = player {
                    audioPlayers[music] = player
                    player.prepareToPlay()
                }
            } catch let error {
                print("*** Sound Box Error: \(error.localizedDescription)")
            }
        }
    }
    
  
    func playMusic(music: String, numberOfLoops: Int) {
        stopMusic()
        let player = audioPlayers[music]
        player?.numberOfLoops = numberOfLoops
        player?.currentTime = 0
        player?.play()
    }
    
    func stopMusic() {
        for (_, player) in audioPlayers {
            player.stop()
        }
    }
    
    let fxBarrel = SKAction.playSoundFileNamed("barrel.mp3", waitForCompletion: false)
    let fxCheat = SKAction.playSoundFileNamed("cheat.mp3", waitForCompletion: false)
    let fxDead = SKAction.playSoundFileNamed("dead.mp3", waitForCompletion: false)
    let fxFlap = SKAction.playSoundFileNamed("flap.mp3", waitForCompletion: false)
    let fxItem = SKAction.playSoundFileNamed("item.mp3", waitForCompletion: false)
    let fxKnife = SKAction.playSoundFileNamed("knife.mp3", waitForCompletion: false)
    let fxNoBullets = SKAction.playSoundFileNamed("nobullets.mp3", waitForCompletion: false)
    let fxPoints = SKAction.playSoundFileNamed("points.mp3", waitForCompletion: false)
    let fxPowerDown = SKAction.playSoundFileNamed("powerdown.mp3", waitForCompletion: false)
    let fxShoot = SKAction.playSoundFileNamed("shoot.mp3", waitForCompletion: false)
}
