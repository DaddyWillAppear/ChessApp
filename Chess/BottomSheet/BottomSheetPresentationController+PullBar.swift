//
//  BottomSheetPresentationController+PullBar.swift
//  Chess
//
//  Created by Николай Щербаков on 07.11.2022.
//

import UIKit

public extension BottomSheetPresentationController {
    final class PullBar: UIView {
        enum Style {
            static let size = CGSize(width: 40, height: 4)
        }
        
        private let centerView: UIView = {
            let view = UIView()
            view.frame.size = Style.size
            view.backgroundColor = .white.withAlphaComponent(0.6)
            view.layer.cornerRadius = Style.size.height * 0.5
            return view
        }()
        
        init() {
            super.init(frame: .zero)
            
            backgroundColor = .clear
            
            setupSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupSubviews() {
            addSubview(centerView)
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            centerView.center = bounds.center
        }
    }
    
    
}
