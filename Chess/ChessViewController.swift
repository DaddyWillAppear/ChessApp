//
//  ViewController.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//
import UIKit

class ChessViewController: UIViewController {
    
    private var colorFlag = true
    let cellSize: CGFloat = 0
    let gameManager = GameManager()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var chessBoardCollectionView: UICollectionView!
    var squareSize = CGSize(width: 20, height: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        squareSize = CGSize(width: (view.bounds.width - 40) / 8, height: (view.bounds.width - 40) / 8)
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        gameManager.setupPieces(playerColor: .white)
        turnLabel.isHidden = false
        chessBoardCollectionView.reloadData()
    }
    
    
    func chessCellColor(for indexPath: IndexPath)-> UIColor {
        var color: UIColor = .white
        if colorFlag == true {
            color = .systemGray6
        } else {
            color = .brown
        }
        if indexPath.row != 7 {
            colorFlag.toggle()
        }
        
        return color
    }
    
    func setImage(for piece: Piece?)-> UIImage? {
        guard let piece = piece else { return nil }

        switch piece.pieceType {
        case .king: if piece.color == .white { return UIImage(named: "KingWhite") } else { return UIImage(named: "KingBlack") }
        case .queen: if piece.color == .white { return UIImage(named: "QueenWhite") } else { return UIImage(named: "QueenBlack") }
        case .bishop: if piece.color == .white { return UIImage(named: "BishopWhite") } else { return UIImage(named: "BishopBlack") }
        case .knight: if piece.color == .white { return UIImage(named: "KnightWhite") } else { return UIImage(named: "KnightBlack") }
        case .rook: if piece.color == .white { return UIImage(named: "RookWhite") } else { return UIImage(named: "RookBlack") }
        case .pawn: if piece.color == .white { return UIImage(named: "PawnWhite") } else { return UIImage(named: "PawnBlack") }
        }
    }
}

extension ChessViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if gameManager.isMate == false {
            if gameManager.squareSelected(by: (indexPath.section,indexPath.row)) == true {
                collectionView.reloadData()
            }
            if gameManager.turn == .white { turnLabel.text = "White turn"} else { turnLabel.text = "Black turn" }
            
            if gameManager.isMate == true {
                var winString: String = ""
                if gameManager.getOpponentColor(gameManager.turn) == .white { winString = "WhiteSideWon"} else { winString = "BlackSideWon" }
                titleLabel.text = winString
            }
        }
    }
}

extension ChessViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "squareCell", for: indexPath) as? SquareCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = chessCellColor(for: indexPath)
        let square = gameManager.board.board[indexPath.section][indexPath.row]
        let piece = square.piece
        cell.pieceImageView.image = setImage(for: piece)
        if square.availableForMove == true {
            cell.availabilityView.isHidden = false
        } else { cell.availabilityView.isHidden = true }
        return cell
    }
}

extension ChessViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(chessBoardCollectionView.bounds.width / 8)
        let height = width
        return CGSize(width: width, height: height)
    }
}
