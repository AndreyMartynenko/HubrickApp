//
//  CommentStats.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import Foundation
import Firebase

struct CommentStats {
    
    let key: String?
    let ref: DatabaseReference?
    
    let count: Int
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        key = snapshot.key
        ref = snapshot.ref
        
        if let count = value["count"] as? Int { self.count = count } else { self.count = 0 }
    }
}
