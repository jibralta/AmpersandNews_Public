//
//  ArticlesFeedCell.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 1/15/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import UIKit

class ArticlesFeedCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleInfoLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    var buttonTappedAction: ((UITableViewCell) -> Void)? = nil
    
    // MARK: Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()

        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = CGSize.zero
        cardView.layer.shadowRadius = 1.25
        
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        buttonTappedAction?(self)
    }
    
}

