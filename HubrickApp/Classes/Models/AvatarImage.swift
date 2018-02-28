//
//  AvatarImage.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import Foundation
import Firebase

struct AvatarImage {
    
    let key: String?
    let ref: DatabaseReference?
    
    let url: String?
    let mimeType: String?
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        key = snapshot.key
        ref = snapshot.ref
        
        if let url = value["url"] as? String { self.url = url } else { self.url = nil }
        if let mimeType = value["mimeType"] as? String { self.mimeType = mimeType } else { self.mimeType = nil }
    }
}
