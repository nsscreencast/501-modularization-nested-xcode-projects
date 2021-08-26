//
//  InfoViewController.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 7/2/21.
//

import UIKit
import SnapKit
import SwiftUI

class InfoViewController: UIViewController {
    let stack = UIStackView()
    let infoLabel = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        title = NSLocalizedString("info.title", tableName: nil, bundle: .main, value: "Info", comment: "Info screen title")

        tabBarItem = UITabBarItem(title: title,
                                  image: UIImage(systemName: "info"),
                                  selectedImage: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stack.axis = .vertical
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20))
        }
        
        infoLabel.font = .appFont(size: 40)
        infoLabel.textColor = .label
        infoLabel.numberOfLines = -1
        infoLabel.textAlignment = .center
        
        stack.addArrangedSubview(infoLabel)
        updateInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo), name: .mealsChanged, object: nil)
    }
    
    @objc
    private func updateInfo() {
        let weekInterval = weekInterval(containing: Date())
        let mealsThisWeek = CurrentState.mealStore.meals.filter { meal in
            weekInterval.contains(meal.date)
        }
        
        infoLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("meals_planned_count", comment: "You have %d meals planned this week")
            , mealsThisWeek.count)
    }
    
    private func weekInterval(containing date: Date) -> DateInterval {
        // CAUTION: This code won't work for every locale
        let calendar = Calendar.current
        var start = calendar.startOfDay(for: date)
        while calendar.component(.weekday, from: start) > 1 {
            start = calendar.date(byAdding: .day, value: -1, to: start)!
        }
        let end = calendar.date(byAdding: .day, value: 7, to: start)!
        return DateInterval(start: start, end: end)
    }
}


struct InfoViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        let info = InfoViewController()
        let nav = UINavigationController(rootViewController: info)
        let tabs = UITabBarController()
        tabs.viewControllers = [nav]
        return tabs
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
    }
}
struct InfoViewController_Previews: PreviewProvider {
    static var previews: some View {
        InfoViewControllerRepresentable()
    }
}
