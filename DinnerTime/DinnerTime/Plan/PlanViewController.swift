//
//  PlanViewController.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/4/21.
//

import UIKit
import Models
import Styleguide
import Controls

class PlanViewDataSource: UITableViewDiffableDataSource<Date, Meal> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class PlanViewController: UITableViewController {
    
    private let dateFormatter = DateFormatter()
    
    private var autoScrollToIndexPath: IndexPath?
    
    var planDays: [PlanDay] = []
    
    var diffableDatasource: PlanViewDataSource!
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
        diffableDatasource = PlanViewDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, itemIdentifier in
            let mealCell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as! MealCell
            let meal = self.meal(for: indexPath)
            mealCell.textLabel?.text = meal.name
            return mealCell
        })
        
        title = .localized.planTitle
        tabBarItem = UITabBarItem(title: title, image: tabBarImage(), selectedImage: nil)
        tableView.delegate = self
        dateFormatter.dateStyle = .full
        loadPlan()
        updateSnapshot(animated: false)
        
        autoScrollToIndexPath = indexPathForDate(Date())
    }
    
    private func meal(for indexPath: IndexPath) -> Meal {
        let planDay = planDays[indexPath.section]
        let meal = planDay.meals[indexPath.row]
        return meal
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLayoutSubviews()
        
        if let autoScrollToIndexPath = autoScrollToIndexPath,
           tableView.numberOfSections >= autoScrollToIndexPath.section {
            tableView.scrollToRow(at: autoScrollToIndexPath, at: .top, animated: false)
            self.autoScrollToIndexPath = nil
        }
    }
    
    private func tabBarImage() -> UIImage {
        let source = UIImage(named: "Dining")
        let size = CGSize(width: 32, height: 32)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            source?.draw(in: .init(origin: .zero, size: size))
        }
    }
    
    private func updateSnapshot(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Date, Meal>()
        snapshot.appendSections(planDays.map(\.date))
        for planDay in planDays {
            snapshot.appendItems(planDay.meals, toSection: planDay.date)
        }
        diffableDatasource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func loadPlan() {
        let daysForward = 14
        let daysBack = 7
        
        let calendar = Calendar.current
        
        var dayOffset = -daysBack
        let today = calendar.startOfDay(for: Date())
        
        precondition(dayOffset < daysForward)
        var planDays: [PlanDay] = []
        while dayOffset <= daysForward {
            defer { dayOffset += 1 }
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else {
                continue
            }

            // any meals on this day?
            let meals = CurrentState.mealStore.meals(on: date)
            planDays.append(PlanDay(date: date, meals: meals))
        }
        self.planDays = planDays
    }
    
    private func indexPathForDate(_ date: Date) -> IndexPath? {
        let calendar = Calendar.current
        guard let section = planDays.firstIndex(where: { planDay in
            calendar.isDate(planDay.date, inSameDayAs: date)
        }) else { return nil }
        
        return IndexPath(row: NSNotFound, section: section)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let meal = diffableDatasource.itemIdentifier(for: indexPath) else { return }
        let mealFormVC = MealFormViewController(meal: meal, mode: .edit)
        mealFormVC.mealSaved = { [unowned self] meal in
            CurrentState.mealStore.update(meal)
            self.loadPlan()
            self.updateSnapshot(animated: false)
            self.dismiss(animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let addMealNav = UINavigationController(rootViewController: mealFormVC)
        present(addMealNav, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dateFormatter.string(from: planDays[section].date)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        
        let headerLabel = UILabel()
        headerLabel.font = .appFont(size: 16)
        headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerLabel.textColor = .secondaryLabel
        
        stack.addArrangedSubview(headerLabel)
        
        return PaddedView(wrapping: stack, padding: UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5))
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let addMealButton = DashedBorderButton()
        addMealButton.tag = section
        addMealButton.setTitle(
            .localized.addMealButtonTitle
            , for: .normal)
        addMealButton.addTarget(self, action: #selector(addMealTapped(sender:)), for: .touchUpInside)
        
        addMealButton.snp.makeConstraints { make in
            make.height.equalTo(40).priority(.required)
        }
        
        return PaddedView(wrapping: addMealButton, padding: UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0))
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: .localized.delete) { action, view, completion in
            let meal = self.meal(for: indexPath)
            CurrentState.mealStore.remove(meal)
            self.loadPlan()
            self.updateSnapshot(animated: true)
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
    
    @objc private func addMealTapped(sender: UIButton) {
        print("addMealTapped for section: \(sender.tag)")
        let planDay = planDays[sender.tag]
        let meal = Meal(name: "", date: planDay.date, type: .dinner)
        let addMealVC = MealFormViewController(meal: meal, mode: .new)
        addMealVC.mealSaved = { [unowned self] meal in
            print("Save meal: ")
            dump(meal)
            self.dismiss(animated: true, completion: nil)
            CurrentState.mealStore.add(meal)
            self.loadPlan()
            self.updateSnapshot(animated: true)
        }
        let addMealNav = UINavigationController(rootViewController: addMealVC)
        present(addMealNav, animated: true, completion: nil)
    }
}
