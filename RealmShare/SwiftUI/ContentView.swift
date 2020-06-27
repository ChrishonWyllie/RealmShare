//
//  ContentView.swift
//  RealmShare
//
//  Created by Chrishon Wyllie on 6/26/20.
//  Copyright © 2020 Chrishon Wyllie. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @State private var isAlert = false
    @State var showSheet = false
    
    var body: some View {
        NavigationView {
            UserListView()
            .navigationBarItems(trailing:
                HStack {
                    Button("Share") {
                        self.isAlert.toggle()
                    }.alert(isPresented: $isAlert) { () -> Alert in
                        Alert(title: Text("Export").font(.title),
                              message: Text("Choose export file").font(.subheadline),
                              primaryButton: .default(Text("User List"), action: {
                                
                                
                                
                                let exportable = ExportableContainer<User>()
                                let url = exportable.convertDataSourceToUserListFile()!
                                let activityViewController = SwiftUIActivityViewController()
                                activityViewController.share(url: url)
                                
                              }),
                              secondaryButton: .default(Text("CSV")))
                    }

                    Button("Add") {
                        Array(0..<10).forEach { (num) in
                            let user = User()
                            user.userId = UUID().uuidString
                            user.fullName = "Some name"
                            user.numCoffees = 0
                            
                            do {
                                let realm = try Realm()
                                try realm.write {
                                    realm.add(user)
                                }
                            } catch let error {
                                print("Error writing to Realm: \(error)")
                            }
                        }
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UserListView: View {
    
    private var users: Results<User>!
    
    init() {
        do {
            let realm = try Realm()
            users = realm.objects(User.self)
        } catch let error {
            print("Error getting users: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(users, id: \.userId) { user in
                    UserListCell(user: user)
                }
            }
        }
    }
}




struct UserListCell: View {
    let user: User
    var body: some View {
        VStack (alignment: .leading) {
            Text(user.userId ?? "")
            Text(user.fullName ?? "")
            Text("\(user.numCoffees)")
        }
    }
}















class ActivityViewController : UIViewController {

    var url: URL!

    @objc func share() {
        let activityItems: [Any] = [url!]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
        
        activityController.excludedActivityTypes =  [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        activityController.popoverPresentationController?.sourceView = self.view
        
        
        present(activityController, animated: true, completion: nil)
        
    }
    
}



struct SwiftUIActivityViewController : UIViewControllerRepresentable {

    let activityViewController = ActivityViewController()

    func makeUIViewController(context: Context) -> ActivityViewController {
        activityViewController
    }
    func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {
        //
    }
    func share(url: URL) {
        activityViewController.url = url
        activityViewController.share()
    }
}


struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
