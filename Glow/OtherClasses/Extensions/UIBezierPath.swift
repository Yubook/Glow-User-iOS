//
//  UIBezierPath.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/10/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {

    convenience init?(square: CGRect, numberOfSides: UInt, cornerRadius: CGFloat) {

        guard square.width == square.height else { return nil }

        let squareWidth = square.width

        guard numberOfSides > 0 && cornerRadius >= 0.0 && 2.0 * cornerRadius < squareWidth && !square.isInfinite && !square.isEmpty && !square.isNull else {

            return nil
        }

        self.init()

        // how much to turn at every corner
        let theta =  2.0 * .pi / CGFloat(numberOfSides)
        let halfTheta = 0.5 * theta

        // offset from which to start rounding corners
        let offset: CGFloat = cornerRadius * CGFloat(tan(halfTheta))

        var length = squareWidth - self.lineWidth
        if numberOfSides % 4 > 0 {

            length = length * cos(halfTheta)
        }

        let sideLength = length * CGFloat(tan(halfTheta))

        // start drawing at 'point' in lower right corner
        let p1 = 0.5 * (squareWidth + sideLength) - offset
        let p2 = squareWidth - 0.5 * (squareWidth - length)
        var point = CGPoint(x: p1, y: p2)
        var angle = CGFloat.pi

        self.move(to: point)

        // draw the sides around rounded corners of the polygon
        for _ in 0..<numberOfSides {

            let x1 = CGFloat(point.x) + ((sideLength - offset * 2.0) * CGFloat(cos(angle)))
            let y1 = CGFloat(point.y) + ((sideLength - offset * 2.0) * CGFloat(sin(angle)))

            point = CGPoint(x: x1, y: y1)
            self.addLine(to: point)

            let centerX = point.x + cornerRadius * CGFloat(cos(angle + 0.5 * .pi))
            let centerY = point.y + cornerRadius * CGFloat(sin(angle + 0.5 * .pi))
            let center = CGPoint(x: centerX, y: centerY)
            let startAngle = CGFloat(angle) - 0.5 * .pi
            let endAngle = CGFloat(angle) + CGFloat(theta) - 0.5 * .pi

            self.addArc(withCenter: center, radius: cornerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            point = self.currentPoint
            angle += theta

        }

        self.close()
    }
}
