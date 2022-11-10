//
//  PieceMovementStrategyProtocol.swift
//  Chess
//
//  Created by Николай Щербаков on 14.09.2022.
//

import Foundation

protocol PieceMovementStrategy {
    var movementValue: Array<(Int,Int)> { get }
    func availableMoves(on board: Board, by coordinate: (Int,Int))-> Array<(Int,Int)>
}

extension PieceMovementStrategy {
    
    func availableMoves(on board: Board, by coordinate: (Int,Int))-> Array<(Int,Int)> {
        var array = Array<(Int,Int)>()
        let movementArray = movementValue
        for moveValue in movementArray {
            array.append(contentsOf: availableMovesHelper(coordinate: coordinate, direction: moveValue, board: board))
        }
        return array
    }
    
    func availableMovesHelper(coordinate: (Int,Int), direction: (Int,Int), board: Board) -> Array<(Int,Int)> {
        var movesArray = Array<(Int,Int)>()
        var tmpCoordinate = coordinate
        let piece = board.getPiece(by: coordinate)!
        tmpCoordinate.0 += direction.0
        tmpCoordinate.1 += direction.1
        while (tmpCoordinate.0 <= board.boardSize && tmpCoordinate.0 >= 0) && (tmpCoordinate.1  <= board.boardSize && tmpCoordinate.1 >= 0) {
            if board.getPiece(by: tmpCoordinate) == nil {
                movesArray.append(tmpCoordinate)
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
                tmpCoordinate.0 += direction.0
                tmpCoordinate.1 += direction.1
            } else if piece.color != board.getPiece(by: tmpCoordinate)?.color {
                movesArray.append(tmpCoordinate)
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
                break
            } else if board.getPiece(by: tmpCoordinate)?.color == board.getPiece(by: coordinate)?.color {
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
                break
            }
        }
        return movesArray
    }
}
