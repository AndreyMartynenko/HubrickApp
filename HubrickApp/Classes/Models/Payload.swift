//
//  Payload.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import Foundation
import Firebase

struct Payload {
    
    let key: String?
    let ref: DatabaseReference?
    
    let stats: Stats?
    let plainTitle: String?
    let plainContentPreview: String?
    let path: String?
    let headLineImage: HeadLineImage?
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        key = snapshot.key
        ref = snapshot.ref
        
        if snapshot.hasChild("stats") { self.stats = Stats(snapshot: snapshot.childSnapshot(forPath: "stats")) } else { self.stats = nil }
        if let plainTitle = value["plainTitle"] as? String { self.plainTitle = plainTitle } else { self.plainTitle = nil }
        if let plainContentPreview = value["plainContentPreview"] as? String { self.plainContentPreview = plainContentPreview } else { self.plainContentPreview = nil }
        if let path = value["path"] as? String { self.path = path } else { self.path = nil }
        if snapshot.hasChild("headLineImage") { self.headLineImage = HeadLineImage(snapshot: snapshot.childSnapshot(forPath: "headLineImage")) } else { self.headLineImage = nil }
    }
}
