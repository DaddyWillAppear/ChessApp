//
//  Square.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//

import Foundation

class Square {
    var availableForMove: Bool = false
    var piece: Piece?
    var underAttackArray: Dictionary<Color,Int> = [.white : 0, .black: 0]
}
