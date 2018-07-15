//
//  Constants.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 18/3/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

struct Constants {
    

    
    static let SPRITES_ATLAS = SKTextureAtlas.init(named: "sprites.atlas")
    
    static let device = UIScreen.main.traitCollection.userInterfaceIdiom
    
    static let FONT_NAME = "Old Pixel-7"
        
    static let TEXTURE_ZOOM = CGFloat(4)
    static let GROUND_TEXTURE_ZOOM = CGFloat(6)

    static let ZPOS_JOYSTICK = CGFloat(1000)
    static let ZPOS_GAME_TEXT = CGFloat(15000)
    static let ZPOS_HUD = CGFloat(20000)
    static let ZPOS_GAME_SPRITE = CGFloat(1000)
    
    static var GAME_SCALE : CGFloat {
        return Constants.device == .pad ? 0.8 : 0.6
    }
    static let GROUND_SAFE_AREA_BOTTOM = CGFloat(40)
    static let GROUND_SAFE_AREA_TOP = CGFloat(80)
    
    static let PLAYER_OFFSET_X = CGFloat(400)
    static var PLAYER_VX : CGFloat {
        return Constants.device == .pad ? CGFloat(120) : CGFloat(95)
    }
    static let PLAYER_INITIAL_BULLETS = 50
    static let PLAYER_MAX_BULLETS = 100
    
    static let COLLISION_PERSPECTIVE_ADJUSTMENT = CGFloat(0.70)
    static let PROJECTILE_SHADOW_ADJUSTMENT = CGFloat(-35.0)
    
    static let INDIAN_POINTS = 200
    static let BAD_GUY_POINTS = 100
    
    static let BULLET_IMPULSE = CGFloat(0.15)
    static let KNIFE_IMPULSE = CGFloat(2)
    
    static let POINTS_MONEY_BAG = 500
    static let POINTS_INDIAN_KILLED = 200
    static let POINTS_BADGUY_KILLED = 100
    static let POINTS_FOR_SILVER_MEDAL = 3000
    static let SILVER_MEDAL_ACHIEVEMENT_IDENTIFIER = "com.pixfans.GunsAndRiders.SheriffSilverStar"
    static let POINTS_FOR_GOLDEN_MEDAL = 5000
    static let GOLDEN_MEDAL_ACHIEVEMENT_IDENTIFIER = "com.pixfans.GunsAndRiders.SheriffGoldStar"
    static let LEADERBOARD_IDENTIFIER = "com.pixfans.GunsAndRiders.reward"
    
    static let ITEM_BULLETS_NUMBER = 20
    static let POWER_UP_TIME_INTERVAL = 20.0
}
