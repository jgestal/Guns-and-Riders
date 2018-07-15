//
//  Poster.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 24/4/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

enum PosterType: Int {
    case jimmy, kanfor
}

enum PosterLevel :CGFloat {
    case board = 10, moving = 100, enlarged = 200
}

class Poster: SKSpriteNode {
    let posterType : PosterType

    init(posterType: PosterType) {
        var texture : SKTexture!
        self.posterType = posterType
        
        switch posterType {
        case .jimmy:
            texture = Constants.SPRITES_ATLAS.textureNamed("doa_juan_gestal")
        case .kanfor:
            texture = Constants.SPRITES_ATLAS.textureNamed("doa_kanfor")
        }
        let size = CGSize(width: texture.size().width, height: texture.size().height)

        super.init(texture: texture, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
