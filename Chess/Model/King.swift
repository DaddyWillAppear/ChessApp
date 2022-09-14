//
//  King.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//

import Foundation

class King:PieceMovementStrategy {
    
    var movementValue: Array<(Int, Int)> = [(-1,0),(-1,-1),(-1,1),(1,0),(1,1),(1,-1),(0,1),(0,-1)]
    
    func availableMoves(on board: Board, by coordinate: (Int,Int))-> Array<(Int,Int)> {
        var array = Array<(Int,Int)>()
        var color: Color = .black
        let piece = board.getPiece(by: coordinate)!
        if piece.color == .black {
            color = .white
        }
        
        if piece.pieceMoved == false {
            let rook = board.board[coordinate.0][coordinate.1 - 4]
            let rook1 = board.board[coordinate.0][coordinate.1 + 3]
            let knightSquare = board.board[coordinate.0][coordinate.1 - 3]
            let queenSquare = board.board[coordinate.0][coordinate.1 - 1]
            let bishopSquare = board.board[coordinate.0][coordinate.1 + 1]
            let underAttackCheck = board.isSquareUnderAttack(coordinate: (coordinate.0, coordinate.1 - 1), by: color)
            let bishopSquareUnderAttackCheck = board.isSquareUnderAttack(coordinate: (coordinate.0, coordinate.1 + 1), by: color)
            if rook.piece?.pieceType == .rook && rook.piece?.pieceMoved == false && knightSquare.piece == nil && queenSquare.piece == nil && underAttackCheck == false {
                movementValue.append((0,-2))
            }
            if rook1.piece?.pieceType == .rook && rook1.piece?.pieceMoved == false && bishopSquare.piece == nil && bishopSquareUnderAttackCheck == false{
                movementValue.append((0, 2))
            }
        }
        
        for moveValue in movementValue {
            array.append(contentsOf: availableMovesHelper(coordinate: coordinate, direction: moveValue, board: board))
        }
        return array
    }
    
    func availableMovesHelper(coordinate: (Int,Int), direction: (Int,Int), board: Board) -> Array<(Int,Int)> {
        var movesArray = Array<(Int,Int)>()
        let piece = board.getPiece(by: coordinate)!
        var color: Color = .white
        if piece.color == .white {
            color = .black
        }
        var tmpCoordinate = coordinate
        tmpCoordinate.0 += direction.0
        tmpCoordinate.1 += direction.1
        
        if tmpCoordinate.0 <= board.boardSize && tmpCoordinate.0 >= 0 && tmpCoordinate.1  <= board.boardSize && tmpCoordinate.1 >= 0{
            if board.getPiece(by: tmpCoordinate) == nil && board.isSquareUnderAttack(coordinate: tmpCoordinate, by: color) == false {
                movesArray.append(tmpCoordinate)
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
            } else if board.getPiece(by: tmpCoordinate)?.color != board.getPiece(by: coordinate)?.color && board.isSquareUnderAttack(coordinate: tmpCoordinate, by: color) == false {
                movesArray.append(tmpCoordinate)
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
            } else if board.getPiece(by: tmpCoordinate)?.color == board.getPiece(by: coordinate)?.color {
                board.underAttackCheck(coordinate: tmpCoordinate, piece: piece)
            }
        }
        
        return movesArray
    }
}
