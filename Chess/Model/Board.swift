//
//  Board.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//

import Foundation

class Board {
    
    var board: [[Square]]
    let boardSize = 7
    
    private var str: String = "abcdefgh"
    
    init() {
        board = [[Square]]()
        for _ in 0...7 {
            var rowArray = Array<Square>()
            for _ in 0...7 {
                rowArray.append(Square())
            }
            board.append(rowArray)
        }
    }
    
    func discard(availableMoves: Bool, underAttackArray: Bool) {
        for i in 0...boardSize {
            for j in 0...boardSize {
                if availableMoves == true {
                    board[i][j].availableForMove = false
                }
                if underAttackArray == true {
                    board[i][j].underAttackArray[.white] = 0
                    board[i][j].underAttackArray[.black] = 0
                }
            }
        }
    }
    
    
    func getSquare(by coordinate: (Int,Int))-> Square {
        return board[coordinate.0][coordinate.1]
    }
    
    public func setPieces(playerColor: Color) {
        
        for i in 0...boardSize {
            for j in 0...boardSize {
                board[i][j].piece = nil
                board[i][j].underAttackArray[.black] = 0
                board[i][j].underAttackArray[.white] = 0
                board[i][j].availableForMove = false
            }
        }
        
        var upperSide: Color = .black
        var lowerSide: Color = .white
        if playerColor == .black {
            upperSide = .white
            lowerSide = .black
        }
        
        //setting upperSide
        settingPiecesHelper(pawnRow: 1, sideColor: upperSide)
        //setting lowerSide
        settingPiecesHelper(pawnRow: 6, sideColor: lowerSide)
    }
    
    private func settingPiecesHelper(pawnRow: Int, sideColor: Color) {
        var noPawnRow = 0
        if pawnRow == 6 {
            noPawnRow = 7
        }
        board[noPawnRow][0].piece = Piece(pieceType: .rook ,color: sideColor)
        board[noPawnRow][7].piece = Piece(pieceType: .rook ,color: sideColor)
        board[noPawnRow][1].piece = Piece(pieceType: .knight ,color: sideColor)
        board[noPawnRow][6].piece = Piece(pieceType: .knight ,color: sideColor)
        board[noPawnRow][2].piece = Piece(pieceType: .bishop ,color: sideColor)
        board[noPawnRow][5].piece = Piece(pieceType: .bishop ,color: sideColor)
        board[noPawnRow][3].piece = Piece(pieceType: .queen, color: sideColor)
        board[noPawnRow][4].piece = Piece(pieceType: .king, color: sideColor)

        for cell in board[pawnRow] {
            cell.piece = Piece(pieceType: .pawn, color: sideColor)
        }
    }
    
    func getPiece(by coordinate: (Int,Int)) -> Piece? {
        guard let piece = board[coordinate.0][coordinate.1].piece else { return nil }
        return piece
    }
    
    func underAttackCheck(coordinate: (Int,Int), piece: Piece) {
        if board[coordinate.0][coordinate.1].underAttackArray[piece.color] != nil {
            board[coordinate.0][coordinate.1].underAttackArray[piece.color]! += 1
        }
    }
    
    func isSquareUnderAttack(coordinate: (Int,Int), by color: Color) -> Bool {
        if board[coordinate.0][coordinate.1].underAttackArray[color]! > 0 {
            return true
        } else { return false }
    }
}

