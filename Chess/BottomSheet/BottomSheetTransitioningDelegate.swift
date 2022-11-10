//
//  BottomSheetTransitioningDelegate.swift
//  Chess
//
//  Created by Николай Щербаков on 07.11.2022.
//

import UIKit

public protocol BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(presentedViewController: UIViewController, presentingViewController: UIViewController?) -> BottomSheetPresentationController
}

public final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    //MARK: - Private properties
    private weak var presentationController: BottomSheetPresentationController?
    private let presentationControllerFactory: BottomSheetPresentationControllerFactory
    
    public init(presentationControllerFactory: BottomSheetPresentationControllerFactory) {
        self.presentationControllerFactory = presentationControllerFactory
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         presentationController
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        presentationController?.interactiveTransitioning
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        presentationController?.interactiveTransitioning
    }
    //
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        _presentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    private func _presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> BottomSheetPresentationController {
        if let presentationController = presentationController {
            return presentationController
        }
        
        let controller = presentationControllerFactory.makeBottomSheetPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        presentationController = controller
        
        return controller
    }
    
    
    
    
    
    
    
    
}
