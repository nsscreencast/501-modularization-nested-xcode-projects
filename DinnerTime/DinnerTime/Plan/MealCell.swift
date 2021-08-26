//
//  MealCell.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/4/21.
//

import UIKit
import Styleguide

class MealCell: UITableViewCell {
    static let reuseIdentifier = "MealCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        textLabel?.font = .appFont(size: 18)
    }
}
