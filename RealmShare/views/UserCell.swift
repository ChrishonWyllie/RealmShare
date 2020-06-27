//
//  UserCell.swift
//  ClubKit_Example
//
//  Created by Chrishon Wyllie on 5/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ClubKit

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
    private var userCreationInfoStackView = InfoStackView()
    private var userLastVisitInfoStackView = InfoStackView()
    private var userNumVisitsInfoStackView = InfoStackView()
    private var emailAddressInfoStackView = InfoStackView()
    
    private lazy var containerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [usernameInfoStackView, userIdInfoStackView, userCreationInfoStackView, userLastVisitInfoStackView, userNumVisitsInfoStackView, emailAddressInfoStackView])
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
        v.layer.cornerRadius = Constants.UIFormat.roundedCornerRadius
        v.layer.borderWidth = Constants.UIFormat.roundedBorderWidth
        v.layer.borderColor = Constants.ClassicSwiftConstants.AppTheme.primaryColor.cgColor
        
        return v
    }()
    
    
    
    
    // MARK: - Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
    
    public func setup(with user: CustomMembershipUser) {
        usernameInfoStackView.setText(title: "User name:", secondary: user.username)
        userIdInfoStackView.setText(title: "User Unique Id:", secondary: user.userId)
        
        
        
        
        let creationDate = Date(timeIntervalSince1970: user.timeStampAdded)
        let creationDateAsString = dateFormatter.string(from: creationDate)
        userCreationInfoStackView.setText(title: "Date Added:", secondary: creationDateAsString)
        
        let lastVisitDate = Date(timeIntervalSince1970: user.timeStampOfLastVisit)
        let lastVisitDateAsString = dateFormatter.string(from: lastVisitDate)
        userLastVisitInfoStackView.setText(title: "Date of last visit:", secondary: lastVisitDateAsString)
        
        userNumVisitsInfoStackView.setText(title: "Number of visits:", secondary: String(describing: user.numVisits))
        
        emailAddressInfoStackView.setText(title: "Email Address", secondary: user.emailAddress)
    }
    
}
