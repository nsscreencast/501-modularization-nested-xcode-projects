//
//  SolidButton.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/18/21.
//

import UIKit
import Styleguide

public class SolidButton: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let bgOverlayView = UIView()
    
    private func setup() {
        backgroundColor = tintColor
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .appFont(size: 18, bold: true)
        layer.cornerRadius = 14
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        
        heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        bgOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bgOverlayView.isHidden = true
        insertSubview(bgOverlayView, belowSubview: titleLabel!)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bgOverlayView.frame = bounds
    }
    
    public override var isHighlighted: Bool {
        didSet {
            bgOverlayView.isHidden = !isHighlighted
        }
    }

    public override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.5
        }
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        backgroundColor = tintColor
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 46)
    }
}


#if DEBUG
import SwiftUI
struct SolidButtonRepresentable: UIViewRepresentable {
    @State var title: String
    @State var disabled: Bool = false
    
    func makeUIView(context: Context) -> SolidButton {
        let button = SolidButton()
        button.setTitle(title, for: .normal)
        button.isEnabled = !disabled
        return button
    }
    
    func updateUIView(_ button: SolidButton, context: Context) {
        button.setTitle(title, for: .normal)
        button.isEnabled = !disabled
    }
}

struct SolidButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SolidButtonRepresentable(title: "My Button")
                .padding()
                .previewLayout(.fixed(width: 375, height: 100))
            
            SolidButtonRepresentable(title: "My Button", disabled: true)
                .padding()
                .previewLayout(.fixed(width: 375, height: 100))
             
        }
    }
}
#endif
