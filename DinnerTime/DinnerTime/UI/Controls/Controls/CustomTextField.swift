//
//  CustomTextField.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/4/21.
//

import UIKit
import Styleguide

@IBDesignable
public class CustomTextField: UITextField {
    public override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    public override func prepareForInterfaceBuilder() {
        configure()
    }
    
    private func configure() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        font = .appFont(size: 28)
        setContentHuggingPriority(.required, for: .vertical)
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            let verticalPadding: CGFloat = 10
            var size = super.intrinsicContentSize
            size.height += verticalPadding * 2
            return size
        }
    }
}
