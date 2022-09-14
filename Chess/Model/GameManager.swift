//
//  GameManager.swift
//  Chess
//
//  Created by Николай Щербаков on 31.08.2022.
//

import Foundation

class GameManager {
    var board: Board
    var movementManager: MovementManager
    var readyForMove: Bool = false
    var prevPieceCoordinate: (Int,Int)?
    var turn: Color = .white
    var isMate: Bool = false
    
    init() {
        self.board = Board()
        self.movementManager = MovementManager(board: board)
    }
    
    func getOpponentColor(_ playerColor: Color)-> Color {
        if playerColor == .white {
            return .black
        } else { return .white }
    }
    
    func setupPieces(playerColor: Color) {
        prevPieceCoordinate = nil
        turn = .white
        isMate = false
        readyForMove = false
        board.setPieces(playerColor: playerColor)
        movementManager.setupUnderAttackSquares()
    }
    
    func isPawnReadyForTransformation(coordinate: (Int,Int))-> Bool {
        if board.getPiece(by: coordinate)?.pieceType == .pawn && (coordinate.0 == 0 || coordinate.0 == 7)  {
            return true
        } else { return false }
    }
    
    func transformPawn(in coordinate: (Int,Int), to pieceType: PieceType) {
        board.getSquare(by: coordinate).piece?.pieceType = pieceType
    }
    
    private func nextTurn() {
        if turn == .white { turn = .black } else { turn = .white }
    }
    
    func isTurnColorKingCheck(color: Color) -> Bool {
        for i in 0...board.boardSize {
            for j in 0...board.boardSize {
                let piece = board.getPiece(by: (i,j))
                if piece?.pieceType == .king && piece?.color == color {
                    if board.isSquareUnderAttack(coordinate: (i,j), by: getOpponentColor(color)) == true {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func checkCheckmate(color: Color) {
        if isTurnColorKingCheck(color: color) {
            isMate = true
            for i in 0...board.boardSize {
                for j in 0...board.boardSize {
                    if board.getPiece(by: (i,j))?.color == color {
                        let prevCoordinate: (Int,Int) = (i,j)
                        movementManager.availableMoves(by: (i,j)).forEach {
                            let defeatedPiece = movementManager.movePiece(oldCoordinate: (prevCoordinate.0, prevCoordinate.1), newCoordinate: ($0.0,$0.1))
                            if isTurnColorKingCheck(color: color) != true { isMate = false }
                            movementManager.moveBack(defeatedPiece: defeatedPiece, oldCoordinate: (prevCoordinate.0, prevCoordinate.1), currentCoordinate: ($0.0,$0.1))
                        }
                    }
                }
            }
        }
    }

    @discardableResult
    func squareSelected(by coordinate: (Int,Int))-> Bool {
        print("squareSelected")
        //if manager has previous coordinate (piece available for move)
        if let prevPieceCoordinate = prevPieceCoordinate {
            print("prevCoordinate!=nil")
            //if user chose same color piece for move
            if board.getPiece(by: prevPieceCoordinate)?.color == board.getPiece(by: coordinate)?.color {
                //if user chose same piece
                if prevPieceCoordinate == coordinate {
                    board.discard(availableMoves: true, underAttackArray: false)
                    self.prevPieceCoordinate = nil
                    return true
                }
                
                board.discard(availableMoves: true, underAttackArray: false)
                for movementsCoordinate in movementManager.availableMoves(by: coordinate) {
                    board.getSquare(by: movementsCoordinate).availableForMove = true
                    self.prevPieceCoordinate = coordinate
                }
                return true
            }
            
            //if did not chose same color piece and chose available square
            if board.getSquare(by: coordinate).availableForMove == true {
                print("AVailableForMove")
                //roque
                if board.getPiece(by: prevPieceCoordinate)?.pieceType == .king && (coordinate.1 == prevPieceCoordinate.1 + 2 || coordinate.1 == prevPieceCoordinate.1 - 2) {
                    print("roque")
                    movementManager.movePiece(oldCoordinate: prevPieceCoordinate, newCoordinate: coordinate)
                    if coordinate.1 == prevPieceCoordinate.1 + 2 {
                        movementManager.movePiece(oldCoordinate: (prevPieceCoordinate.0,prevPieceCoordinate.1 + 3), newCoordinate: (coordinate.0,coordinate.1 - 1))
                    }
                    if coordinate.1 == prevPieceCoordinate.1 - 2 {
                        movementManager.movePiece(oldCoordinate: (prevPieceCoordinate.0,prevPieceCoordinate.1 - 4), newCoordinate: (coordinate.0,coordinate.1 + 1))
                    }
                    self.prevPieceCoordinate = nil
                    checkCheckmate(color: getOpponentColor(turn))
                    nextTurn()
                    return true
                }
                
                let piece = board.getPiece(by: prevPieceCoordinate)
                let isMoved = piece?.pieceMoved
                guard let isMoved = isMoved else { fatalError("Cannot get isMoved state for existing piece") }
                print("ready")
                let defeatedPiece = movementManager.movePiece(oldCoordinate: prevPieceCoordinate, newCoordinate: coordinate)
                print("afterMove")
                
                //if user's move makes his king under attack
                if isTurnColorKingCheck(color: turn) == true {
                    movementManager.moveBack(defeatedPiece: defeatedPiece, oldCoordinate: prevPieceCoordinate, currentCoordinate: coordinate)
                    piece?.pieceMoved = isMoved
                    return true
                }
                checkCheckmate(color: getOpponentColor(turn))
                nextTurn()
                self.prevPieceCoordinate = nil
                return true
            }
        } else if board.getPiece(by: coordinate) != nil {
            guard board.getPiece(by: coordinate)?.color == turn else { return false }
            self.prevPieceCoordinate = coordinate
            for movementsCoordinate in movementManager.availableMoves(by: coordinate) {
                board.getSquare(by: movementsCoordinate).availableForMove = true
            }
            return true
        }
        return false
    }
}
