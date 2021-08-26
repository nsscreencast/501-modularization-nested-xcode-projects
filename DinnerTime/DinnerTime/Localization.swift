import Foundation
import Models

struct Localization {
    fileprivate init() { }
    
    var planTitle: String {
        NSLocalizedString("plan.title", tableName: nil, bundle: .main, value: "Meal Plan", comment: "Meal plan screen title")
    }
    
    var addMealButtonTitle: String {
        NSLocalizedString("plan.add_meal", tableName: nil, bundle: .main, value: "Add Meal", comment: "Add meal button title")
    }
    
    var delete: String {
        NSLocalizedString("delete", tableName: nil, bundle: .main, value: "Delete", comment: "Delete button title")
    }
    
    var mealFormNamePlaceholder: String {
        NSLocalizedString("meal_form.name_placeholder", tableName: nil, bundle: .main, value: "Meal", comment: "Meal form name textfield placeholder")
    }
    
    var mealFormAddMealTitle: String {
        NSLocalizedString("meal_form.add_meal_title", tableName: nil, bundle: .main, value: "Add Meal", comment: "Add Meal screen title")
    }
    
    var mealFormEditMealTitle: String {
        NSLocalizedString("meal_form.edit_meal_title", tableName: nil, bundle: .main, value: "Edit Meal", comment: "Edit Meal screen title")
    }
    
    var mealFormAddMealButtonTitle: String {
        NSLocalizedString("meal_form.add_meal_button", tableName: nil, bundle: .main, value: "Add meal", comment: "Add Meal button title")
    }
    
    var mealFormUpdateMealButtonTitle: String {
        NSLocalizedString("meal_form.update_meal_button", tableName: nil, bundle: .main, value: "Update meal", comment: "Update Meal button title")
    }
    
    var infoTitle: String {
        NSLocalizedString("info.title", tableName: nil, bundle: .main, value: "Info", comment: "Info screen title")
    }
    
    var date: String {
        NSLocalizedString("date", tableName: nil, bundle: .main, value: "Date", comment: "Date cell label")
    }
    
    var breakfast: String {
        NSLocalizedString("breakfast", tableName: nil, bundle: .main, value: "Breakfast", comment: "Breakfast")
    }
    
    var lunch: String {
        NSLocalizedString("lunch", tableName: nil, bundle: .main, value: "Lunch", comment: "Lunch")
    }
    
    var dinner: String {
        NSLocalizedString("dinner", tableName: nil, bundle: .main, value: "Dinner", comment: "dinner")
    }
    
    var dessert: String {
        NSLocalizedString("dessert", tableName: nil, bundle: .main, value: "Dessert", comment: "dessert")
    }
    
    var snack: String {
        NSLocalizedString("snack", tableName: nil, bundle: .main, value: "Snack", comment: "snack")
    }
}

extension String {
    static var localized = Localization()
}


extension MealType {
    var localized: String {
        switch self {
        case .breakfast: return .localized.breakfast
        case .lunch: return .localized.lunch
        case .dinner: return .localized.dinner
        case .dessert: return .localized.dessert
        case .snack: return .localized.snack
        }
    }
}
