//
//  SelfReactions.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import Foundation
import Firebase

struct SelfReactions {
    
    let key: String?
    let ref: DatabaseReference?
    
    let like: Int
    let share: Int
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        key = snapshot.key
        ref = snapshot.ref
        
        if let like = value["LIKE"] as? Int { self.like = like } else { self.like = 0 }
        if let share = value["SHARE"] as? Int { self.share = share } else { self.share = 0 }
    }
}
