//
//  FeedViewModel.swift
//  HubrickApp
//
//  Created by Andrey on 2/25/18.
//

import Foundation
import Firebase

protocol FeedViewModelDelegate {
    
    func onFeedItemsFetched()
    func onFeedItemAdded(at index: Int)
    func onFeedItemUpdated(at index: Int)
    func onFeedItemDeleted(at index: Int)
    
}

class FeedViewModel: NSObject {
    
    fileprivate let delegate: FeedViewModelDelegate
    fileprivate let ref: DatabaseReference
    fileprivate var items: [FeedItem]
    fileprivate var shouldSkipObserver: Bool
    
    init(delegate: FeedViewModelDelegate) {
        self.delegate = delegate
        ref = Database.database().reference(withPath: "feedItems")
        items = []
        shouldSkipObserver = true
        
        super.init()
    }
    
    func start() {
        fetchAllItems()
    }
    
    func stop() {
        stopObservingItems()
    }
    
    var itemsCount: Int {
        get {
            return items.count
        }
    }
    
    func itemPressed(at index: Int) {
        
    }
    
    func observeItems() {
        observeItemAddition()
        observeItemUpdate()
    }
    
    func stopObservingItems() {
        ref.removeAllObservers()
    }
}

extension FeedViewModel {
    
    func authorName(at index: Int) -> String? {
        return items[index].author?.name
    }
    
    func authorDescription(at index: Int) -> String? {
        return "__"
    }
    
    func authorImageUrl(at index: Int) -> String? {
        return items[index].author?.avatarImage?.url
    }
    
    func itemImageUrl(at index: Int) -> String? {
        return items[index].payload?.headLineImage?.url
    }
    
    func itemTitle(at index: Int) -> String? {
        return items[index].payload?.plainTitle
    }
    
    func itemDescription(at index: Int) -> String? {
        return items[index].payload?.plainContentPreview
    }
    
    func itemType(at index: Int) -> FeedItemType? {
        if let type = items[index].type {
            switch type {
            case "ADD":
                return FeedItemType.add
            case "UPDATE":
                return FeedItemType.update
            case "DELETE":
                return FeedItemType.delete
            default:
                return nil
            }
        }
        return nil
    }
    
    func socialLikesCount(at index: Int) -> String? {
        return "\(items[index].payload?.stats?.reactionStats?.counts?.like ?? 0)"
    }
    
    func socialCommentsCount(at index: Int) -> String? {
        return "\(items[index].payload?.stats?.commentStats?.count ?? 0)"
    }
    
    func socialSharesCount(at index: Int) -> String? {
        return "\(items[index].payload?.stats?.reactionStats?.counts?.share ?? 0)"
    }
}

extension FeedViewModel {
    
    func addNewItem() {
        parseJson(fileName: "feedItemAdd") { [weak self] (result) in
            if var result = result {
                result["id"] = "\(self?.items.count ?? 0)" as AnyObject
                
                let itemPath = String(format: "%.0f", NSDate().timeIntervalSince1970.rounded())
                self?.ref.child(itemPath).setValue(result)
            }
        }
    }
    
    func updateFirstItem() {
        parseJson(fileName: "feedItemUpdate") { [weak self] (result) in
            if let result = result, let id = result["id"] as? String {
                if let index = self?.items.index(where: { $0.id == id }), let itemPath = self?.items[index].key {
                    self?.ref.child(itemPath).setValue(result)
                }
            }
        }
    }
    
    func deleteFirstItem() {
        parseJson(fileName: "feedItemDelete") { [weak self] (result) in
            if let result = result, let id = result["id"] as? String {
                if let index = self?.items.index(where: { $0.id == id }), let itemPath = self?.items[index].key {
                    self?.ref.child(itemPath).setValue(result)
                }
            }
        }
    }
    
    fileprivate func parseJson(fileName: String, withCompletionHandler completionHandler: @escaping (Dictionary<String, AnyObject>?) -> Void) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("__parseJson: invalid file name")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                completionHandler(jsonResult)
            }
        } catch {
            print("__parseJson: \(error)")
            completionHandler(nil)
        }
    }
}

extension FeedViewModel {
    
    // Initial single time data retrieval
    fileprivate func fetchAllItems() {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var items: [FeedItem] = []
            
            for item in snapshot.children {
                if let feedItem = FeedItem(snapshot: item as! DataSnapshot) {
                    items.append(feedItem)
                }
            }
            
            self.items = items.reversed()
            self.delegate.onFeedItemsFetched()
        })
    }
    
    // Per each data addition
    fileprivate func observeItemAddition() {
        ref.queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
            // This check is needed due to how .observe(.childAdded, ...) is working:
            // ... This event is triggered once for each existing child and then again every time a new child is added to the specified path ...
            if self.shouldSkipObserver {
                self.shouldSkipObserver = false
                return
            }
            
            if let feedItem = FeedItem(snapshot: snapshot) {
                self.items.insert(feedItem, at: 0)
                self.delegate.onFeedItemAdded(at: 0)
            }
        })
    }
    
    // Per each data update and delete since there is no real deletion happening
    fileprivate func observeItemUpdate() {
        ref.observe(.childChanged, with: { (snapshot) in
            if let feedItem = FeedItem(snapshot: snapshot) {
                if let index = self.items.index(where: { $0.id == feedItem.id }) {
                    self.items[index] = feedItem
                    
                    if feedItem.type == FeedItemType.update.rawValue {
                        self.delegate.onFeedItemUpdated(at: index)
                    } else if feedItem.type == FeedItemType.delete.rawValue {
                        self.delegate.onFeedItemDeleted(at: index)
                    }
                }
            }
        })
    }
}
