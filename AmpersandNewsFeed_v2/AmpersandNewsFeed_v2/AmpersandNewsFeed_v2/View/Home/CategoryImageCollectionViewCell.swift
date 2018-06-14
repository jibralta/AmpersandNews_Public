//
//  TopHeadlineCollectionViewCell.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 1/10/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import UIKit


class CategoryImageCollectionViewCell: UICollectionViewCell {
    
//    var delegate: ArticleCellSelectionDelegate?

    // MARK: IBOutlets
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var gradientImgOverlay: UIImageView!
    
    @IBOutlet private weak var top5ArticlesView: UITableView!
    
    func setTableViewDataSourceDelegate<D: UITableViewDelegate & UITableViewDataSource>(_ dataSourceDelegate: D, forRow row: Int) {
        top5ArticlesView.delegate = dataSourceDelegate
        top5ArticlesView.dataSource = dataSourceDelegate
        top5ArticlesView.tag = row
        top5ArticlesView.reloadData()
    }

}

