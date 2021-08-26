//
//  Meal.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/4/21.
//

import Foundation

public struct Meal: Codable {
    public var identifier = UUID()
    public var name: String
    public var date: Date
    public var type: MealType
    
    public init(identifier: UUID = UUID(), name: String, date: Date, type: MealType) {
        self.identifier = identifier
        self.name = name
        self.date = date
        self.type = type
    }
}

extension Meal: Hashable { }
extension Meal: Equatable { }
extension Meal: Identifiable {
    public var id: UUID { identifier }
}
