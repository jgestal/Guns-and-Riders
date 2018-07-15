//
//  CGSize.swift
//  GunsAndRiders
//
//  Created by Juan Gestal Romani on 8/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import CoreGraphics

extension CGSize {
    static func * (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width * right, height: left.height * right)
    }
}
