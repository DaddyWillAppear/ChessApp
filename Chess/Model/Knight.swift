//
//  Knight.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//

import Foundation

class Knight: PieceMovementStrategy {
    var movementValue: Array<(Int, Int)> = [(-1,-2),(-1,2),(-2,-1),(-2,1),(1,-2),(1,2),(2,1),(2,-1)]
    
    func availableMoves(on board: Board, by coordinate: (Int,Int))-> Array<(Int,Int)> {
        var array = Array<(Int,Int)>()
        for moveValue in movementValue {
            array.append(contentsOf: availableMovesHelper(coordinate: coordinate, direction: moveValue, board: board))
        }
        return array
    }
    
    func availableMovesHelper(coordinate: (Int,Int), direction: (Int,Int), board: Board) -> Array<(Int,Int)> {
        var movesArray = Array<(Int,Int)>()
        let piece = board.getPiece(by: coordinate)!
        var tmpCoordinate = coordinate
        tmpCoordinate.0 += direction.0
        tmpCoordinate.1 += direction.1
        
        if tmpCoordinate.0 <= board.boardSize && tmpCoordinate.0 >= 0 && tmpCoordinate.1  <= board.boardSize && tmpCoordinate.1 >= 0{
            if board.getPiece(by: tmpCoordinate) == nil {
                movesArray.append(tmpCoordinate)
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
            } else if board.getPiece(by: tmpCoordinate)?.color != board.getPiece(by: coordinate)?.color {
                movesArray.append(tmpCoordinate)
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
            } else if board.getPiece(by: tmpCoordinate)?.color == board.getPiece(by: coordinate)?.color {
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
            }
        }
        
        return movesArray
    }
}
