//
//  User.swift
//  RealmShare
//
//  Created by Chrishon Wyllie on 6/26/20.
//  Copyright © 2020 Chrishon Wyllie. All rights reserved.
//

import RealmSwift

@objcMembers class User: Object, Codable, Identifiable {
 
    dynamic var userId: String?
    dynamic var fullName: String?
    dynamic var numCoffees: Int = 0
    
    
    override class func primaryKey() -> String? {
        return CodingKeys.userId.rawValue
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case userId
        case fullName
        case numCoffees 
    }
    
    class func variableNamesAsStrings() -> [String] {
        return CodingKeys.allCases.map { $0.rawValue }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userId = try container.decode(String.self, forKey: .userId)
        fullName = try container.decode(String.self, forKey: .fullName)
        numCoffees = try container.decode(Int.self, forKey: .numCoffees)
        
        super.init()
    }
    
    public required init() {
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(userId, forKey: .userId)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(numCoffees, forKey: .numCoffees)
    }
}
