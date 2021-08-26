//
//  MealType.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/4/21.
//

import Foundation

public enum MealType: String, Codable, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case dessert
    case snack
}
