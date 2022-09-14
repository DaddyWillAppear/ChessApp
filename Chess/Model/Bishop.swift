//
//  Bishop.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//

import Foundation

class Bishop: PieceMovementStrategy {
    var movementValue: Array<(Int, Int)> = [(-1,-1), (1,1), (-1,1), (1,-1)]
}

