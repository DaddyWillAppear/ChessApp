//
//  GameMemento.swift
//  Chess
//
//  Created by Николай Щербаков on 14.09.2022.
//

import Foundation

class GameMemento {
    var board: [[Square]]
    var turnColor: Color
    var move: Move
    
    init(board: [[Square]], turnColor: Color, move: Move) {
        self.board = board
        self.turnColor = turnColor
        self.move = move
    }
}
