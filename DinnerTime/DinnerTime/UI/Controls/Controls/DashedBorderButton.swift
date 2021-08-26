//
//  DashedBorderButton.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/21/21.
//

import UIKit

public class DashedBorderButton: UIButton {
    private let strokeLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        titleLabel?.font = .appFont(size: 16, weight: .medium)
        setTitleColor(tintColor, for: .normal)
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
 
        strokeLayer.strokeColor = UIColor.tertiaryLabel.cgColor
        strokeLayer.opacity = 0.5
        strokeLayer.lineDashPattern = [8, 4]
        strokeLayer.lineWidth = 2
        strokeLayer.frame = layer.bounds
        strokeLayer.fillColor = nil
        layer.addSublayer(strokeLayer)
        
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    public override var isHighlighted: Bool {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            backgroundColor = isHighlighted ? .tertiaryLabel : .clear
            strokeLayer.opacity = isHighlighted ? 0 : 0.5
            CATransaction.commit()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: 100, height: 46)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        strokeLayer.frame = layer.bounds
        strokeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
}

#if DEBUG
import SwiftUI

struct DashedBorderButtonRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> DashedBorderButton {
        let button = DashedBorderButton()
        button.setTitle("Button", for: .normal)
        return button
    }
    
    func updateUIView(_ uiView: DashedBorderButton, context: Context) {
    }
}

struct DashedBorderButton_Previews: PreviewProvider {
    static var previews: some View {
        DashedBorderButtonRepresentable()
            .padding()
            .previewLayout(.fixed(width: 375, height: 100))
    }
}
#endif
