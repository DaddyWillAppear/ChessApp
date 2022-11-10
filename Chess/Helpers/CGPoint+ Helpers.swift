//
//  CGFloat + Helpers.swift
//  Chess
//
//  Created by Николай Щербаков on 07.11.2022.
//

import CoreGraphics

public extension CGPoint {
    // MARK: - Equality

    func isAlmostEqual(to other: CGPoint) -> Bool {
        x.isAlmostEqual(to: other.x) && y.isAlmostEqual(to: other.y)
    }

    func isAlmostEqual(to other: CGPoint, error: CGFloat) -> Bool {
        x.isAlmostEqual(to: other.x, error: error) && y.isAlmostEqual(to: other.y, error: error)
    }
}

