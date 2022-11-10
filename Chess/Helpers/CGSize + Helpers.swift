//
//  CGSize + Helpers.swift
//  Chess
//
//  Created by Николай Щербаков on 07.11.2022.
//

import CoreGraphics

public extension CGSize {
    // MARK: - Equality

    func isAlmostEqual(to other: CGSize) -> Bool {
        width.isAlmostEqual(to: other.width) && height.isAlmostEqual(to: other.height)
    }
    
    func isAlmostEqual(to other: CGSize, error: CGFloat) -> Bool {
        width.isAlmostEqual(to: other.width, error: error) && height.isAlmostEqual(to: other.height, error: error)
    }
}
