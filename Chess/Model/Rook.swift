//
//  Rook.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//

import Foundation

class Rook: PieceMovementStrategy {
    var movementValue: Array<(Int, Int)> = [(-1,0), (1,0), (0,1), (0,-1)]
}
