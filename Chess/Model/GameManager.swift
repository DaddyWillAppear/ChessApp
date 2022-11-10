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
    let gameCaretaker: GameCaretaker
    var prevPieceCoordinate: (Int,Int)?
    var turn: Color = .white
    var isMate: Bool = false
    var isStalemate: Bool = false
    var pawnReadyForTransformationCoordinate: (Int,Int) = (-1,-1)
    
    init() {
        self.board = Board()
        self.movementManager = MovementManager(board: board)
        gameCaretaker = GameCaretaker()
    }
    
    func pushMemento(moveFrom: (Int,Int), moveTo: (Int,Int)) {
        var board = self.board.board
        for i in 0...self.board.boardSize {
            for j in 0...self.board.boardSize {
                board[i][j] = self.board.getSquare(by: (i,j)).getSquareCopy()
            }
        }
        gameCaretaker.gameStates.push(GameMemento(board: board, turnColor: turn, move: Move(moveFrom: moveFrom, moveTo: moveTo)))
    }
    
    func moveBack() {
        gameCaretaker.gameStates.pop()
        guard let previousMove = gameCaretaker.gameStates.head else { return }
        restoreGame(memento: previousMove.value)
    }
    
    func restoreGame(memento: GameMemento) {
        for i in 0...self.board.boardSize {
            for j in 0...self.board.boardSize {
                self.board.board[i][j] = memento.board[i][j].getSquareCopy()
            }
        }
        turn = memento.turnColor
    }
    
    func movePiece(oldCoordinate: (Int,Int), newCoordinate: (Int,Int)) {
        setupAmountOfTurnsAfterPieceMoved()
        movementManager.movePiece(oldCoordinate: oldCoordinate, newCoordinate: newCoordinate)
        nextTurn()
        pushMemento(moveFrom: oldCoordinate, moveTo: newCoordinate)
    }
    
    func getOpponentColor(_ playerColor: Color)-> Color {
        if playerColor == .white {
            return .black
        } else { return .white }
    }
    
    func setupAmountOfTurnsAfterPieceMoved() {
        for i in 0...self.board.boardSize {
            for j in 0...self.board.boardSize {
                if self.board.getPiece(by: (i,j)) != nil && self.board.getPiece(by: (i,j))?.pieceMoved == true {
                    self.board.getPiece(by: (i,j))?.turnsAfterMove += 1
                }
            }
        }
    }
    
    func setupPieces(playerColor: Color) {
        gameCaretaker.gameStates.head = nil
        prevPieceCoordinate = nil
        turn = .white
        isMate = false
        board.setPieces(playerColor: playerColor)
        movementManager.setupUnderAttackSquares()
        pushMemento(moveFrom: (-1,-1), moveTo: (-1,-1))
        gameCaretaker.tmpMemento = gameCaretaker.gameStates.head?.value
    }
    
    func isPawnReadyForTransformation(coordinate: (Int,Int))-> Bool {
        if board.getPiece(by: coordinate)?.pieceType == .pawn && (coordinate.0 == 0 || coordinate.0 == 7) {
            pawnReadyForTransformationCoordinate = coordinate
            return true
        } else { return false }
    }
    
    func transformPawn(in coordinate: (Int,Int), to pieceType: PieceType) {
        board.getPiece(by: coordinate)?.pieceType = pieceType
        movementManager.setupUnderAttackSquares()
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
    
    func checkStalemate(color: Color) {
        isStalemate = true
        for i in 0...self.board.boardSize {
            for j in 0...self.board.boardSize {
                if board.getPiece(by: (i,j)) != nil && board.getPiece(by: (i,j))?.color == color {
                    if !movementManager.availableMoves(by: (i,j)).isEmpty {
                        isStalemate = false
                    }
                }
            }
        }
    }

    func checkCheckmate(color: Color) {
        if isTurnColorKingCheck(color: color) {
            isMate = true
            for i in 0...board.boardSize {
                for j in 0...board.boardSize {
                    if board.getPiece(by: (i,j)) != nil && board.getPiece(by: (i,j))?.color == color {
                        let prevCoordinate: (Int,Int) = (i,j)
                        movementManager.availableMoves(by: (i,j)).forEach {
                            movePiece(oldCoordinate: (prevCoordinate.0, prevCoordinate.1), newCoordinate: ($0.0,$0.1))
                            if isTurnColorKingCheck(color: color) != true { isMate = false }
                            moveBack()
                        }
                    }
                }
            }
        }
    }

    @discardableResult
    func squareSelected(by coordinate: (Int,Int))-> Bool {
        //if manager has previous coordinate (piece available for move)
        if let prevPieceCoordinate = prevPieceCoordinate {
            //if user chose same color piece for move
            if board.getPiece(by: prevPieceCoordinate)?.color == board.getPiece(by: coordinate)?.color {
                //if user chose same piece
                if prevPieceCoordinate == coordinate {
                    board.discard(availableMoves: true, underAttackArray: false, piece: false)
                    self.prevPieceCoordinate = nil
                    return true
                }
                
                board.discard(availableMoves: true, underAttackArray: false, piece: false)
                for movementsCoordinate in movementManager.availableMoves(by: coordinate) {
                    board.getSquare(by: movementsCoordinate).availableForMove = true
                    self.prevPieceCoordinate = coordinate
                }
                return true
            }
            
            //if did not chose same color piece and chose available square
            if board.getSquare(by: coordinate).availableForMove == true {
                //roque
                if board.getPiece(by: prevPieceCoordinate)?.pieceType == .king && (coordinate.1 == prevPieceCoordinate.1 + 2 || coordinate.1 == prevPieceCoordinate.1 - 2) {
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
                
                if board.getPiece(by: prevPieceCoordinate)?.pieceType == .pawn && board.getPiece(by: coordinate) == nil && coordinate.1 != prevPieceCoordinate.1 {
                    board.getSquare(by: (prevPieceCoordinate.0, coordinate.1)).piece = nil
                }
                
                movePiece(oldCoordinate: prevPieceCoordinate, newCoordinate: coordinate)
                //if user's move makes his king under attack
                if isTurnColorKingCheck(color: getOpponentColor(turn)) == true {
                    moveBack()
                    self.prevPieceCoordinate = nil
                    return false
                }
                checkCheckmate(color: turn)
                checkStalemate(color: turn)
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
