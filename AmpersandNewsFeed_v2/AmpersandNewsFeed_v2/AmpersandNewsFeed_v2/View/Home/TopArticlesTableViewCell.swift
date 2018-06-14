//
//  Top5HeadlinesTableViewCell.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 1/25/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import UIKit

class TopArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var newsSourceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
