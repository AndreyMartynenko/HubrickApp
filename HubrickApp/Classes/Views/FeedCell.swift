//
//  FeedCell.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var authorNameLabel: UILabel!
    @IBOutlet fileprivate weak var authorDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var authorImageView: UIImageView!
    @IBOutlet fileprivate weak var feedImageView: UIImageView!
    @IBOutlet fileprivate weak var feedTitleLabel: UILabel!
    @IBOutlet fileprivate weak var feedDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var socialLikesLabel: UILabel!
    @IBOutlet fileprivate weak var socialCommentsLablel: UILabel!
    @IBOutlet fileprivate weak var socialSharesLabel: UILabel!
    
    override func prepareForReuse() {
        authorNameLabel.textColor = UIColor.black
        authorDescriptionLabel.textColor = UIColor.darkGray
        feedTitleLabel.textColor = UIColor.black
        feedDescriptionLabel.textColor = UIColor.darkGray
        
        authorImageView.image = nil
        feedImageView.image = nil
    }
    
    func setAuthorName(name: String?) {
        authorNameLabel.text = name
    }
    
    func setAuthorDescription(description: String?) {
        authorDescriptionLabel.text = description
    }
    
    func setAuthorImage(stringUrl: String?) {
        authorImageView.imageFromUrl(urlString: stringUrl)
    }
    
    func setItemImage(stringUrl: String?) {
        feedImageView.imageFromUrl(urlString: stringUrl)
    }
    
    func setItemTitle(title: String?) {
        feedTitleLabel.text = title
    }
    
    func setItemDescription(description: String?) {
        feedDescriptionLabel.text = description
    }
    
    func setItemType(type: FeedItemType?) {
        if type == .delete {
            grayOutContent()
        }
    }
    
    func setSocialLikesCount(count: String?) {
        socialLikesLabel.text = count
    }
    
    func setSocialCommentsCount(count: String?) {
        socialCommentsLablel.text = count
    }
    
    func setSocialSharesCount(count: String?) {
        socialSharesLabel.text = count
    }
    
    fileprivate func grayOutContent() {
        authorNameLabel.textColor = UIColor.lightGray
        authorDescriptionLabel.textColor = UIColor.lightGray
        feedTitleLabel.textColor = UIColor.lightGray
        feedDescriptionLabel.textColor = UIColor.lightGray
    }
}
