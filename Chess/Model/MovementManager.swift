//
//  MovementManager.swift
//  Chess
//
//  Created by Николай Щербаков on 11.09.2022.
//

import Foundation

class MovementManager {
    
    var board: Board
    
    init(board: Board) {
        self.board = board
    }
    
    private func pieceDetermination(coordinate: (Int,Int))-> PieceMovementStrategy? {
        guard let piece = board.getPiece(by: (coordinate.0,coordinate.1)) else { return nil }
        switch piece.pieceType {
        case .bishop: return Bishop()
        case .pawn:  return Pawn()
        case .knight: return Knight()
        case .rook: return Rook()
        case .queen: return Queen()
        case .king: return King()
        }
    }
    
    func setupUnderAttackSquares() {
        board.discard(availableMoves: true, underAttackArray: true)
        
        for i in 0...board.boardSize {
            for j in 0...board.boardSize {
                if board.getPiece(by: (i,j)) != nil {
                    availableMoves(by: (i,j))
                }
            }
        }
    }
    
    @discardableResult
    func movePiece(oldCoordinate: (Int,Int), newCoordinate: (Int,Int))-> Piece? {
        let piece = board.board[oldCoordinate.0][oldCoordinate.1].piece
        let defeatedPiece = board.board[newCoordinate.0][newCoordinate.1].piece
        board.board[oldCoordinate.0][oldCoordinate.1].piece = nil
        board.board[newCoordinate.0][newCoordinate.1].piece = piece
        piece?.pieceMoved = true
        board.discard(availableMoves: true, underAttackArray: true)
        setupUnderAttackSquares()
        return defeatedPiece
    }
    
    func moveBack(defeatedPiece: Piece?, oldCoordinate: (Int,Int), currentCoordinate: (Int,Int)) {
        board.getSquare(by: oldCoordinate).piece = board.getPiece(by: currentCoordinate)
        board.getSquare(by: currentCoordinate).piece = defeatedPiece
        board.discard(availableMoves: true, underAttackArray: true)
        setupUnderAttackSquares()
    }
    
    @discardableResult
    func availableMoves(by coordinate: (Int,Int)) -> Array<(Int,Int)> {
        guard let pieceMovementStrategy:PieceMovementStrategy = pieceDetermination(coordinate: coordinate) else { return [] }
        return pieceMovementStrategy.availableMoves(on: board, by: coordinate)
    }
}
