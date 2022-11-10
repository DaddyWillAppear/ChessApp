//
//  Pawn.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022. //79174675327
//

import Foundation

class Pawn: PieceMovementStrategy {
    var movementValue: Array<(Int, Int)> = [(-1,0), (-1,-1), (-1,1)]
    
    func availableMoves(on board: Board, by coordinate: (Int,Int))-> Array<(Int,Int)> {
        if abs(board.boardSize / 2 - coordinate.0) == 2 || abs(board.boardSize / 2  - coordinate.0) == 3 {
            movementValue.append((-2,0))
        }
        if board.getPiece(by: coordinate)?.color == .black {
            var tmpMovementValueArray = Array<(Int,Int)>()
            movementValue.forEach({
                let value:(Int,Int) = ($0.0 * -1, $0.1 * -1)
                tmpMovementValueArray.append(value)
            })
            movementValue = tmpMovementValueArray
        }
        var array = Array<(Int,Int)>()
        for moveValue in movementValue {
            array.append(contentsOf: availableMovesHelper(coordinate: coordinate, direction: moveValue, board: board))
        }
        
        return array
    }
    
    func availableMovesHelper(coordinate: (Int,Int), direction: (Int,Int), board: Board) -> Array<(Int,Int)> {
        var movesArray = Array<(Int,Int)>()
        
        var tmpCoordinate = coordinate
        tmpCoordinate.0 += direction.0
        tmpCoordinate.1 += direction.1
        let piece = board.getPiece(by: coordinate)!
        
        if tmpCoordinate.0 <= board.boardSize && tmpCoordinate.0 >= 0 && tmpCoordinate.1  <= board.boardSize && tmpCoordinate.1 >= 0 {
            
            if board.getPiece(by: tmpCoordinate) == nil {
                if direction.1 == 0 {
                    movesArray.append(tmpCoordinate)
                } else {
                    if direction.1 == -1 && board.getPiece(by: (coordinate.0, coordinate.1 - 1))?.pieceType == .pawn && board.getPiece(by: (coordinate.0, coordinate.1 - 1))?.turnsAfterMove == 1 {
                        movesArray.append(tmpCoordinate)
                    }
                    if direction.1 == 1 && board.getPiece(by: (coordinate.0, coordinate.1 + 1))?.pieceType == .pawn && board.getPiece(by: (coordinate.0, coordinate.1 + 1))?.turnsAfterMove == 1 {
                        movesArray.append(tmpCoordinate)
                    }
                    
                    board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
                }
            } else if board.getPiece(by: tmpCoordinate)?.color != board.getPiece(by: coordinate)?.color {
                if direction.1 != 0 {
                    movesArray.append(tmpCoordinate)
                    board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
                }
            } else if board.getPiece(by: tmpCoordinate)?.color == board.getPiece(by: coordinate)?.color {
                if direction.1 != 0 {
                    board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
                }
    
            }
        }
        
        return movesArray
    }
}
