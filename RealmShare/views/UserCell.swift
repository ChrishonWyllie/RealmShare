//
//  UserCell.swift
//  RealmShare
//
//  Created by Chrishon Wyllie on 6/26/20.
//  Copyright © 2020 Chrishon Wyllie. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    
    // MARK: - Variables
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm a"
        formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }
    
    
    
    
    // MARK: - UI Elements
    
    private var usernameInfoStackView = InfoStackView()
    private var userIdInfoStackView = InfoStackView()
    private var userNumVisitsInfoStackView = InfoStackView()
    
    private lazy var containerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [usernameInfoStackView, userIdInfoStackView, userNumVisitsInfoStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 10
        return sv
    }()
    
    private var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.backgroundColor = UIColor.systemBackground
        v.layer.cornerRadius = 15
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.systemRed.cgColor
        
        return v
    }()
    
    
    
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUIElements()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    // MARK: - Functions
    
    private func setupUIElements() {
        contentView.addSubview(containerView)
        containerView.addSubview(containerStackView)
        
        let paddingConstant: CGFloat = 8
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingConstant).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingConstant).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingConstant).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingConstant).isActive = true
        
        containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: paddingConstant).isActive = true
        containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: paddingConstant).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -paddingConstant).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -paddingConstant).isActive = true
    }
    
    public func setup(with user: User) {
        usernameInfoStackView.setText(title: "User name:", secondary: user.fullName)
        userIdInfoStackView.setText(title: "User Unique Id:", secondary: user.userId)
        userNumVisitsInfoStackView.setText(title: "Number of visits:", secondary: String(describing: user.numCoffees))
    }
    
}
