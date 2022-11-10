//
//  ViewController.swift
//  Chess
//
//  Created by Николай Щербаков on 12.08.2022.
//
import UIKit

class ChessViewController: UIViewController {
    
    private var bottomSheetTransitioningDelegate: UIViewControllerTransitioningDelegate?
    
    private var colorFlag = true
    let cellSize: CGFloat = 0
    let gameManager = GameManager()
    
    var per: CGFloat = 1
    
    var padding: CGFloat = 20 {
        didSet {
            squareSize = CGSize(width: (view.bounds.width - padding * 2) / 8, height: (view.bounds.width - padding * 2) / 8)
            chessBoardCollectionViewWidthConstraint.constant = squareSize.width * 8
            chessBoardCVLeadingConstraint.constant = padding
            chessBoardCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    @IBOutlet weak var chessBoardCVLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var chessBoardCollectionView: UICollectionView!
    @IBOutlet weak var chessBoardCollectionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pawnTransformationMainStackView: UIStackView!
    @IBOutlet weak var pawnTransformationMainStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pawnTransformationMainStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pawnTransformationMainStackViewLeadingConstraint: NSLayoutConstraint!
    var squareSize = CGSize(width: 20, height: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        padding = view.bounds.width / 20
        
        pawnTransformationMainStackViewWidthConstraint.constant = squareSize.width
        setupPawnTransformationStackView(color: .white)
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        gameManager.setupPieces(playerColor: .white)
        turnLabel.isHidden = false
        chessBoardCollectionView.reloadData()
    }
    
    @IBAction func transformPawn(_ sender: Any) {
        guard sender is UIButton else { return }
        guard let button = sender as? PawnTransformationButton else { return }
        gameManager.transformPawn(in: gameManager.pawnReadyForTransformationCoordinate, to: button.pieceType)
        pawnTransformationMainStackView.isHidden = true
        chessBoardCollectionView.reloadData()
    }
    
    @IBAction func cancelTransformPawn(_ sender: Any) {
        gameManager.moveBack()
        pawnTransformationMainStackView.isHidden = true
        chessBoardCollectionView.reloadData()
    }
    
    func prepareMovesArrayForSegue() -> Array<Move> {
        var array = Array<Move>()
        guard var stack = gameManager.gameCaretaker.gameStates.reversed() else { return [] }
        while let value = stack.pop() {
            let move = value.move
            array.append(move)
        }
        
        return array
    }
    
    @IBAction func executeTransitionButton(_ sender: Any) {
        
        guard let destination = storyboard?.instantiateViewController(withIdentifier: "MovesHistoryVC") as? MovesHistoryViewController else {
            return
        }
        
        bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
        let windowInsets = view.window?.safeAreaInsets ?? .zero
        let cvHeight = squareSize.height * 8
        let preferredHeight = view.bounds.height - chessBoardCollectionView.frame.origin.y - cvHeight - windowInsets.bottom - 20
        
        destination.setPreferredContentSizeHeight(preferredHeight)
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = bottomSheetTransitioningDelegate
        destination.movesArray = prepareMovesArrayForSegue()
        
        present(destination, animated: true, completion: nil)
    }
    
    private func setupPawnTransformationStackView(color: Color) {
        let pieceTypeArray: Array<PieceType> = [.queen, .knight, .rook, .bishop]
        let pieceImageArrayWhite: Array<UIImage?> = [UIImage(named: "QueenWhite"), UIImage(named: "KnightWhite"), UIImage(named: "RookWhite"), UIImage(named: "BishopWhite") ]
        let pieceImageArrayBlack: Array<UIImage?> = [UIImage(named: "QueenBlack"), UIImage(named: "KnightBlack"), UIImage(named: "RookBlack"), UIImage(named: "BishopBlack")]
        
        for index in 0...3 {
            guard let button = pawnTransformationMainStackView.arrangedSubviews[index] as? PawnTransformationButton else { return }
            button.pieceType = pieceTypeArray[index]
            if color == .white {
                button.configuration?.background.image = pieceImageArrayWhite[index]
            } else {
                button.configuration?.background.image = pieceImageArrayBlack[index]
            }
        }
    }
    
    
    private func chessCellColor(for indexPath: IndexPath)-> UIColor {
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
        if gameManager.isMate == false && gameManager.isStalemate == false {
            if gameManager.squareSelected(by: (indexPath.section,indexPath.row)) == true {
                //put into function
                if gameManager.isPawnReadyForTransformation(coordinate: (indexPath.section,indexPath.row)) {
                    pawnTransformationMainStackViewLeadingConstraint.constant = CGFloat(indexPath.row) * squareSize.width
                    
                    if indexPath.section == 0 {
                        pawnTransformationMainStackViewTopConstraint.constant = 0
                    }
                    if indexPath.section == 7 {
                        pawnTransformationMainStackViewTopConstraint.constant = collectionView.bounds.height / 2
                    }
                    pawnTransformationMainStackView.isHidden = false
                }
                //
                collectionView.reloadData()
            }
            if gameManager.turn == .white { turnLabel.text = "White turn"} else { turnLabel.text = "Black turn" }
            
            if gameManager.isMate == true {
                var winString: String = ""
                if gameManager.getOpponentColor(gameManager.turn) == .white { winString = "WhiteSideWon"} else { winString = "BlackSideWon" }
                titleLabel.text = winString
            }
            if gameManager.isStalemate == true {
                titleLabel.text = "Stalemate"
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
        return squareSize
    }
}

extension ChessViewController: BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(presentedViewController: UIViewController, presentingViewController: UIViewController?) -> BottomSheetPresentationController {
        .init(presentedViewController: presentedViewController, presentingController: presentingViewController, dismissalHandler: self)
    }
    
    
}

extension ChessViewController: BottomSheetModalDismissalHandler {
    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
    }
}
