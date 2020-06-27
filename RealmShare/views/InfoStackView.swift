//
//  InfoStackView.swift
//  ClubKit_Example
//
//  Created by Chrishon Wyllie on 5/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

// A UIView that has a title UILabel and secondary
// UILabel aligned vertically.
class InfoStackView: UIView {
    
    private var titleLabel: UnderlinedLabel = {
        let lbl = UnderlinedLabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var secondaryLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, secondaryLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = UIStackViewAlignment.leading
        sv.spacing = 6
        return sv
    }()
    
    
    
    init() {
        super.init(frame: .zero)
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUIElements() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    public func setText(title: String? = nil, secondary: String? = nil) {
        if let title = title {
            self.titleLabel.text = title
        }
        if let secondary = secondary {
            self.secondaryLabel.text = secondary
        }
    }
}









// MARK: - UnderlinedLabel
// Just a UILabel that has underlined-text for convenience
// Meant to act as a "title" label
class UnderlinedLabel: UILabel {

    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttributes([
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor : UIColor.darkGray,
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ],
                                         range: textRange)
            self.attributedText = attributedText
        }
    }
}
