//
//  Stats.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import Foundation
import Firebase

struct Stats {
    
    let key: String?
    let ref: DatabaseReference?
    
    let reactionStats: ReactionStats?
    let commentStats: CommentStats?
    
    init?(snapshot: DataSnapshot) {
        if snapshot.childrenCount == 0 {
            return nil
        }
        
        key = snapshot.key
        ref = snapshot.ref
        
        if snapshot.hasChild("reactionStats") { self.reactionStats = ReactionStats(snapshot: snapshot.childSnapshot(forPath: "reactionStats")) } else { self.reactionStats = nil }
        if snapshot.hasChild("commentStats") { self.commentStats = CommentStats(snapshot: snapshot.childSnapshot(forPath: "commentStats")) } else { self.commentStats = nil }
    }
}
