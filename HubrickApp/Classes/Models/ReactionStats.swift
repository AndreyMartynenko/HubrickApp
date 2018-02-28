//
//  ReactionStats.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import Foundation
import Firebase

struct ReactionStats {
    
    let key: String?
    let ref: DatabaseReference?
    
    let counts: Counts?
    let selfReactions: SelfReactions?
    
    init?(snapshot: DataSnapshot) {
        if snapshot.childrenCount == 0 {
            return nil
        }
        
        key = snapshot.key
        ref = snapshot.ref
        
        if snapshot.hasChild("counts") { self.counts = Counts(snapshot: snapshot.childSnapshot(forPath: "counts")) } else { self.counts = nil }
        if snapshot.hasChild("selfReactions") { self.selfReactions = SelfReactions(snapshot: snapshot.childSnapshot(forPath: "selfReactions")) } else { self.selfReactions = nil }
    }
}
