//
//  CGVector.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 3/7/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import CoreGraphics

extension CGVector {
    
    static func normalized(from: CGPoint, to: CGPoint) -> CGVector {
        // Vector components
        var dx = to.x - from.x
        var dy = to.y - from.y
        // Normalize the components
        let magnitude = sqrt(dx*dx + dy*dy)
        dx /= magnitude
        dy /= magnitude
        return CGVector(dx: dx, dy: dy)
    }
    
    static func * (left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx * right, dy: left.dy * right)
    }
    
}
