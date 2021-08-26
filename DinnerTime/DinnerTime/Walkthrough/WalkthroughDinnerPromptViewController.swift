//
//  WalkthroughDinnerPromptViewController.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/4/21.
//

import UIKit

class WalkthroughDinnerPromptViewController: UIViewController {
    
    weak var walkthroughDelegate: WalkthroughDelegate?
    
    @IBOutlet private weak var textField: UITextField!
    
    @IBAction private func skipTapped() {
        walkthroughDelegate?.didCompleteWalkthrough(firstDinner: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
    }
}

extension WalkthroughDinnerPromptViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        walkthroughDelegate?.didCompleteWalkthrough(firstDinner: textField.text)
        return true
    }
}
