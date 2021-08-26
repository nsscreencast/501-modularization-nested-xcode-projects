//
//  DatePickerCell.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 7/2/21.
//

import UIKit
import SnapKit
import SwiftUI

class DatePickerCell: UITableViewCell {
    let label = UILabel()
    let datePicker = UIDatePicker()
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        selectionStyle = .none
        
        let stack = UIStackView()
        
        label.text = .localized.date
        label.font = .appFont(size: 18)
        label.textColor = .secondaryLabel
                
        datePicker.calendar = .autoupdatingCurrent
        datePicker.datePickerMode = .date
        datePicker.setContentHuggingPriority(.required, for: .horizontal)
        
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(datePicker)
        
        label.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(1.8)
        }

        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 14, bottom: 4, right: 14))
        }
    }
}


#if DEBUG

struct DatePickerCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> DatePickerCell {
        DatePickerCell()
    }
    
    func updateUIView(_ uiView: DatePickerCell, context: Context) {
    }
}

struct DatePickerCell_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerCellRepresentable()
            .border(Color.gray)
            .previewLayout(.fixed(width: 375, height: 58))
    }
}

#endif
