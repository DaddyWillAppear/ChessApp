//
//  Move.swift
//  Chess
//
//  Created by Николай Щербаков on 05.09.2022.
//

import Foundation

class Move {
    
    var moveFrom: (Int,Int)
    var moveTo: (Int,Int)
    
    init(moveFrom: (Int,Int), moveTo: (Int,Int)) {
        self.moveFrom = moveFrom
        self.moveTo = moveTo
    }
}
