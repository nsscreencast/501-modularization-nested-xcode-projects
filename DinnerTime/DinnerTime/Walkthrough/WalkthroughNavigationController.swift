//
//  WalkthroughViewController.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/3/21.
//

import UIKit

protocol WalkthroughDelegate: AnyObject {
    func didCompleteWalkthrough(firstDinner: String?)
}

class WalkthroughNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    weak var walkthroughDelegate: WalkthroughDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        isModalInPresentation = true
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? WalkthroughDinnerPromptViewController {
            vc.walkthroughDelegate = walkthroughDelegate
        }
    }
}
