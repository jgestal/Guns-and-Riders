//
//  SKAction+Extension.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 2/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

extension SKAction {
    
    static func blink (repetitions: Int) -> SKAction {
        
        let blinkAction =  SKAction.sequence([
            SKAction.fadeAlpha(to: 0, duration: 0.1),
            SKAction.wait(forDuration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1),
            SKAction.wait(forDuration: 0.1)
            ])
        
        return SKAction.repeat(blinkAction, count: repetitions)
    }
}
