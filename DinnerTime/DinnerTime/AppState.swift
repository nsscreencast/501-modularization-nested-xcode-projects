//
//  AppState.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/4/21.
//

import Foundation
import Models
import Store

struct AppState {
    let mealStore: MealStore
}

let CurrentState = AppState(
    mealStore: MealStore(storage: Storage(filename: "meals.json"))
)
