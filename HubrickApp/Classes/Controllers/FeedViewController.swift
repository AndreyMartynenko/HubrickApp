//
//  FeedViewController.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import UIKit
import Toast_Swift

class FeedViewController: UITableViewController {
    
    // MARK: - Properties
    
    static let RefreshFeedItemsNotification = "RefreshFeedItemsNotification"
    
    fileprivate var viewModel: FeedViewModel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FeedViewModel(delegate: self)
        viewModel.start()
        
        title = "Feed"
        tableView.estimatedRowHeight = 436
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.observeItems()
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRefreshFeedItemsNotification(_:)), name: NSNotification.Name(FeedViewController.RefreshFeedItemsNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.stopObservingItems()
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        viewModel.stop()
    }
    
    // MARK: - Notifications
    
    @objc func receivedRefreshFeedItemsNotification(_ notification: Notification) {
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func addFeedItemButtonPressed(_ sender: UIBarButtonItem) {
        viewModel.addNewItem()
    }
    
    @IBAction func updateFeedItemButtonPressed(_ sender: UIBarButtonItem) {
        viewModel.updateFirstItem()
    }
    
    @IBAction func deleteFeedItemButtonPressed(_ sender: UIBarButtonItem) {
        viewModel.deleteFirstItem()
    }
}

// MARK: - UITableView delegate methods

extension FeedViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        cell.setAuthorName(name: viewModel.authorName(at: indexPath.row))
        cell.setAuthorDescription(description: viewModel.authorDescription(at: indexPath.row))
        cell.setAuthorImage(stringUrl: viewModel.authorImageUrl(at: indexPath.row))
        cell.setItemImage(stringUrl: viewModel.itemImageUrl(at: indexPath.row))
        cell.setItemTitle(title: viewModel.itemTitle(at: indexPath.row))
        cell.setItemDescription(description: viewModel.itemDescription(at: indexPath.row))
        cell.setItemType(type: viewModel.itemType(at: indexPath.row))
        cell.setSocialLikesCount(count: viewModel.socialLikesCount(at: indexPath.row))
        cell.setSocialCommentsCount(count: viewModel.socialCommentsCount(at: indexPath.row))
        cell.setSocialSharesCount(count: viewModel.socialSharesCount(at: indexPath.row))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.itemPressed(at: indexPath.row)
    }
}

// MARK: - FeedViewModel delegate methods

extension FeedViewController: FeedViewModelDelegate {
    
    func onFeedItemsFetched() {
        tableView.reloadData()
    }
    
    func onFeedItemAdded(at index: Int) {
        if tableView.contentOffset.y > 0 {
            navigationController?.view.hideAllToasts()
            navigationController?.view.makeToast("New content is available", duration: .greatestFiniteMagnitude, position: .bottom, title: nil, image: nil, style: ToastStyle(), completion: { (didTap) in
                if didTap {
                    UIView.performWithoutAnimation {
                        self.tableView.reloadData()
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
                    }
                }
            })
        } else {
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func onFeedItemUpdated(at index: Int) {
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            tableView.endUpdates()
        }
    }
    
    func onFeedItemDeleted(at index: Int) {
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            tableView.endUpdates()
        }
    }
}
