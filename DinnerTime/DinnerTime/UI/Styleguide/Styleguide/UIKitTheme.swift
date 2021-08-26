//
//  UIKitTheme.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/7/21.
//

import UIKit

public struct UIKitTheme {
    public static func apply() {
        let navBars = UINavigationBar.appearance()
        navBars.titleTextAttributes = [
            .font: UIFont.appFont(size: 18, bold: true)
        ]
        
        let buttonLabels = UILabel.appearance(whenContainedInInstancesOf: [UIButton.self])
        buttonLabels.font = .appFont(size: 16)
    }
}
