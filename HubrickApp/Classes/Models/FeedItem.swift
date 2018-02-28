//
//  FeedItem.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import Foundation
import Firebase

enum FeedItemType: String {
    case add = "ADD"
    case update = "UPDATE"
    case delete = "DELETE"
}

struct FeedItem {
    
    let key: String?
    let ref: DatabaseReference?
    
    let id: String?
    let type: String?
    let author: Author?
    let payload: Payload?
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        key = snapshot.key
        ref = snapshot.ref
        
        if let id = value["id"] as? String { self.id = id } else { self.id = nil }
        if let type = value["type"] as? String { self.type = type } else { self.type = nil }
        if snapshot.hasChild("author") { self.author = Author(snapshot: snapshot.childSnapshot(forPath: "author")) } else { self.author = nil }
        if snapshot.hasChild("payload") { self.payload = Payload(snapshot: snapshot.childSnapshot(forPath: "payload")) } else { self.payload = nil }
    }
}
