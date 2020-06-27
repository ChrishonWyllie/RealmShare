//
//  UserListViewController.swift
//  ClubKit_Example
//
//  Created by Chrishon Wyllie on 5/26/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ClubKit

class UserListViewController: UIViewController {
    
    // MARK: - Variables
    
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private let usersCollection = MembershipUserCollection<CustomMembershipUser>()
    
    
    // MARK: - UI Elements
    
    private var numUsersLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()
    
    private lazy var tableView: UITableView = {
        let tbv = UITableView(frame: .zero)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = UIColor.white
        tbv.delegate = self
        tbv.dataSource = self
        tbv.alwaysBounceVertical = true
        tbv.separatorStyle = .none
        return tbv
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUIElements()
        loadAllRecords()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        // Allow edit actions on the tableview, such as deleting users
        tableView.setEditing(editing, animated: true)
    }
    
    private lazy var exportAllButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Export", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showExportSheetController))
        return btn
    }()
    
    @objc private func showExportSheetController() {
        
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        
        let alertController = UIAlertController(title: "Export",
                                                message: "Choose export file",
                                                preferredStyle: alertStyle)
        let userListFileAction = UIAlertAction(title: "User List", style: UIAlertActionStyle.default) { (_) in
            guard
                let exportableURL = Club.shared.getExportableURLForDataSource(ofType: CustomMembershipUser.self, fileType: .userList)
                else {
                return
            }
            
            self.showShareController(with: exportableURL)
        }
        let csvFileAction = UIAlertAction(title: "CSV", style: UIAlertActionStyle.default) { (_) in
            guard
                let exportableURL = Club.shared.getExportableURLForDataSource(ofType: CustomMembershipUser.self, fileType: .csv)
                else {
                return
            }
            
            self.showShareController(with: exportableURL)
        }
        
        alertController.addAction(userListFileAction)
        alertController.addAction(csvFileAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showShareController(with exportableURL: URL) {
        let activityItems: [Any] = [
            exportableURL
        ]
        
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // iPad requires a source view and CGRect for displaying
        // popover views
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = self.view
            activityController.popoverPresentationController?.barButtonItem = self.exportAllButton
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    private func stressTestAddingManyUsers() {
        // Creates 10,000 users
        // NOTE
        // Freezes the UI for atleast 2 full minutes
        // but otherwise, completes without crashing
        // There is no reason to do this more than once
        Array(0..<10000).forEach { (num) in
            let captureDataString = "4|\(UUID().uuidString)|whatever|username_\(num)"
            let newUserInfoformation = CaptureDataInformation(captureDataString: captureDataString)!
            Club.shared.createUser(with: newUserInfoformation)
        }
    }
    
    private func setupUIElements() {
        
        self.title = "Stored Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        // right to left
        navigationItem.rightBarButtonItems = [
            exportAllButton,
            editButtonItem
        ]
        self.editButtonItem.tintColor = Constants.ClassicSwiftConstants.AppTheme.primaryColor
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(numUsersLabel)
        view.addSubview(tableView)
        
        numUsersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        numUsersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        numUsersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        numUsersLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: numUsersLabel.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
    }
    
    private func loadAllRecords() {
        
        usersCollection.observeAllRecords({ [weak self] (changes: MembershipUserChanges) in
            guard let strongSelf = self else { return }
            
            switch changes {
            case .initial(_):
                strongSelf.tableView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                strongSelf.tableView.performBatchUpdates({
                    strongSelf.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    strongSelf.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    strongSelf.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                }, completion: { (completed: Bool) in
                    strongSelf.tableView.reloadData()
                })
                break
            case let .error(error):
                print(error.localizedDescription)
            }
            
        })
    }
}






// MARK: - UITableViewDelegate and UITableViewDataSource

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = usersCollection.users.count
        numUsersLabel.text = "Num users: \(numRows)"
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? UserCell
        
        let user = usersCollection.users[indexPath.item]
        cell?.setup(with: user)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let updateTitle = "Update Email"
        let updateAction = UIContextualAction(style: .normal, title: updateTitle, handler: { [weak self] (action, view, completionHandler) in
            guard let strongSelf = self else { return }
            let user = strongSelf.usersCollection.users[indexPath.item]
            
            strongSelf.showAlertForUpdating(user: user)
            
            completionHandler(true)
        })
        
        let deleteTitle = "Delete"
        let deleteAction = UIContextualAction(style: .destructive, title: deleteTitle, handler: { [weak self] (action, view, completionHandler) in
            guard let strongSelf = self else { return }
            let user = strongSelf.usersCollection.users[indexPath.item]
            
            strongSelf.showAlertForDeleting(user: user)
            completionHandler(true)
        })

        let configuration = UISwipeActionsConfiguration(actions: [updateAction, deleteAction])
        return configuration
    }
    
    private func showAlertForUpdating(user: CustomMembershipUser) {
        
        let alertController = UIAlertController(title: "Update Email Address",
                                                message: "Provide new email address for \(user.username!)",
                                                preferredStyle: .alert)
        alertController.addTextField()

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Confirm", style: .default) { [unowned alertController] _ in
            
            if let newEmailAddress = alertController.textFields?.first?.text {
                
                Club.shared.update(user: user) {
                    user.emailAddress = newEmailAddress
                }
            }
            
        }

        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)

        present(alertController, animated: true)
    }
    
    private func showAlertForDeleting(user: CustomMembershipUser) {
        
        let title = "Are you sure you want to delete this user?"
        let message = "This is a permanent action and cannot be reversed"
        let style = UIAlertControllerStyle.alert
        
        
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: style)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) { (_) in
            Club.shared.deleteUser(user)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
        
    }
}
