//
//  Author.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import Foundation
import Firebase

struct Author {
    
    let key: String?
    let ref: DatabaseReference?
    
    let name: String?
    let displayName: String?
    let avatarImage: AvatarImage?
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        key = snapshot.key
        ref = snapshot.ref
        
        if let name = value["name"] as? String { self.name = name } else { self.name = nil }
        if let displayName = value["displayName"] as? String { self.displayName = displayName } else { self.displayName = nil }
        if snapshot.hasChild("avatarImage") { self.avatarImage = AvatarImage(snapshot: snapshot.childSnapshot(forPath: "avatarImage")) } else { self.avatarImage = nil }
    }
}
