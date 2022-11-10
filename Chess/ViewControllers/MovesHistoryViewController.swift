//
//  MovesHistoryViewController.swift
//  Chess
//
//  Created by Николай Щербаков on 20.09.2022.
//

import UIKit

class MovesHistoryViewController: UIViewController {
    
    @IBOutlet weak var movesHistoryCollectionView: UICollectionView!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    var segmentedViewSelectedColor: Color = .white
    
    var movesArray: Array<Move> = []
    var whiteMovesArray: Array<Move> = []
    var blackMovesArray: Array<Move> = []
    
    private var currentHeight: CGFloat = 600 {
        didSet {
            preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<movesArray.count {
            if i % 2 == 0 {
                whiteMovesArray.append(movesArray[i])
            } else {
                blackMovesArray.append(movesArray[i])
            }
        }
    }

    public func setPreferredContentSizeHeight(_ height: CGFloat) {
        currentHeight = height
    }
    
    
    
    @IBAction func changeColorSegmentedControl(_ sender: Any) {
        if colorSegmentedControl.selectedSegmentIndex == 0 {
            segmentedViewSelectedColor = .white
        } else { segmentedViewSelectedColor = .black }
        movesHistoryCollectionView.reloadData()
    }
}

extension MovesHistoryViewController: UICollectionViewDelegate {
    
    
}

extension MovesHistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number = movesArray.count / 2
        if segmentedViewSelectedColor == .white && movesArray.count % 2 != 0 {
            number += 1
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moveCell", for: indexPath) as? MovesHistoryCollectionViewCell else { return UICollectionViewCell() }
        if segmentedViewSelectedColor == .white {
            cell.moveLabel.text = "\(whiteMovesArray[indexPath.row].moveFrom), \(whiteMovesArray[indexPath.row].moveTo)"
        } else {
            cell.moveLabel.text = "\(blackMovesArray[indexPath.row].moveFrom), \(blackMovesArray[indexPath.row].moveTo)"
        }
        return cell
    }
    
    
}


extension MovesHistoryViewController: ScrollableBottomSheetPresentedController {
    var scrollView: UIScrollView? {
        movesHistoryCollectionView
    }
}
