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
    
    public func getSquareCopy()-> Square {
        let square = Square()
        square.availableForMove = self.availableForMove
        square.underAttackArray = self.underAttackArray
        if piece == nil {
            square.piece = nil
        } else {
            square.piece = self.piece?.getPieceCopy()
        }
        
        return square
    }
}
