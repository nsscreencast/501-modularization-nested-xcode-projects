//
//  UIFont+appFont.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/4/21.
//

import UIKit

public extension UIFont {
    
    static func appFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        let roundedDesc = font.fontDescriptor.withDesign(.rounded)!
        return UIFont(descriptor: roundedDesc, size: size)
    }
    
    static func appFont(size: CGFloat, bold: Bool = false) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: bold ? .bold : .regular)
        let roundedDesc = font.fontDescriptor.withDesign(.rounded)!
        return UIFont(descriptor: roundedDesc, size: size)
    }
}
