//
//  MealFormViewController.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/6/21.
//

import UIKit
import Models
import Styleguide
import Controls

class MealFormViewController: UITableViewController {
    
    enum Mode {
        case new
        case edit
        
        var screenTitle: String {
            switch self {
            case .new: return .localized.mealFormAddMealTitle
            case .edit: return .localized.mealFormEditMealTitle
            }
        }
        
        var saveButtonTitle: String {
            switch self {
            case .new: return .localized.mealFormAddMealButtonTitle
            case .edit: return .localized.mealFormUpdateMealButtonTitle
            }
        }
    }
    
    enum Sections: Int, CaseIterable {
        case primary
        case mealType
    }
    
    enum PrimaryRows: Int, CaseIterable {
        case name
        case date
    }
    
    var mealSaved: (Meal) -> Void = { _ in }
    
    private var mode: Mode = .new
    private let dateFormatter = DateFormatter()
    
    private var nameTextField: UITextField!
    private var nameCell: UITableViewCell!
    private var dateCell: DatePickerCell!
    private var mealTypeCell: UITableViewCell!
    
    private var saveButton: UIButton!
    
    private var meal: Meal
    
    init(meal: Meal, mode: Mode) {
        self.meal = meal
        self.mode = mode
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        meal = Meal(name: "", date: Date(), type: .dinner)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .full
        
        nameTextField = UITextField()
        nameTextField.borderStyle = .none
        nameTextField.placeholder = .localized.mealFormNamePlaceholder
        nameTextField.font = .appFont(size: 24)
        nameTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        nameTextField.leftViewMode = .always
        nameTextField.rightView = UIView(frame: .init(x: 0, y: 0, width: 20, height: 10))
        nameTextField.rightViewMode = .always
        
        title = mode.screenTitle
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Sections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .primary: return PrimaryRows.allCases.count
        case .mealType: return MealType.allCases.count
        }
    }
    
    private func primaryCell(at indexPath: IndexPath) -> UITableViewCell {
       switch PrimaryRows(rawValue: indexPath.row)! {
        case .name:
            if nameCell == nil {
                nameCell = UITableViewCell()
                nameCell.selectionStyle = .none
                nameCell.contentView.addSubview(nameTextField)
                nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
                nameTextField.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                    make.height.equalTo(68).priority(999)
                }
            }
           nameTextField.text = meal.name
           return nameCell
            
        case .date:
            if dateCell == nil {
                dateCell = DatePickerCell()
                dateCell.datePicker.date = meal.date
                dateCell.datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
            }
            return dateCell
       }
    }
    
    private func mealTypeCell(at indexPath: IndexPath) -> UITableViewCell {
        let mealType = MealType.allCases[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = mealType.localized
        if meal.type == mealType {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.font = .appFont(size: 18)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections(rawValue: indexPath.section)! {
        case .primary: return primaryCell(at: indexPath)
        case .mealType: return mealTypeCell(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath)")
        switch Sections(rawValue: indexPath.section)! {
        case .primary: return
        case .mealType:
            let oldIndexPath = IndexPath(row: MealType.indexOf(meal.type), section: indexPath.section)
            let oldCell = tableView.cellForRow(at: oldIndexPath)
            oldCell?.accessoryType = .none
            
            meal.type = MealType.allCases[indexPath.row]
            let newCell = tableView.cellForRow(at: indexPath)
            newCell?.accessoryType = .checkmark
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField?.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard section == Sections.allCases.count - 1 else {
            return nil
        }
        
        if saveButton == nil {
            saveButton = SolidButton()
            saveButton.setTitle(mode.saveButtonTitle, for: .normal)
            saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
            updateButtonState()
        }
        
        return PaddedView(wrapping: saveButton, padding: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    private func updateButtonState() {
        saveButton.isEnabled = !meal.name.isEmpty
    }
    
    @objc
    private func nameChanged() {
        meal.name = nameTextField.text ?? ""
        updateButtonState()
    }
    
    @objc
    private func dateChanged(sender: UIDatePicker) {
        meal.date = sender.date
    }
    
    @objc
    private func saveTapped() {
        mealSaved(meal)
    }
}

private extension MealType {
    static func indexOf(_ mealType: MealType) -> Int {
        allCases.firstIndex(of: mealType)!
    }
}

#if DEBUG
import SwiftUI
struct MealFormControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let meal = Meal(name: "Pizza", date: Date(), type: .dinner)
        let mealFormVC = MealFormViewController(meal: meal, mode: .new)
        return mealFormVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct MealFormController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MealFormControllerRepresentable()
        }
    }
}
#endif

