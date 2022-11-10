//
//  Piece.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//

import Foundation

enum Color {
    case white
    case black
}

enum PieceType {
    case pawn
    case knight
    case bishop
    case rook
    case king
    case queen
}

class Piece {
    var color: Color
    var pieceType: PieceType
    var pieceMoved: Bool
    var turnsAfterMove: Int = 0
    
    init(pieceType: PieceType, color: Color) {
        self.pieceMoved = false
        self.color = color
        self.pieceType = pieceType
    }
    
    public func getPieceCopy() -> Piece {
        let piece = Piece(pieceType: self.pieceType, color: self.color)
        piece.pieceMoved = self.pieceMoved
        return piece
    }
}

