//
//  ArticleFeedViewController.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 1/21/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import UIKit

class ArticleFeedViewController: UIViewController {
    
    // MARK: Properties
    var navTitle = String()
    
    var articles = [Article]()
    
    let dataSource = DataSource()
    
    var articlesOfSelectedCategory = [Article]()
    var selectedArticleIndexPath: IndexPath?
    
    // MARK: IBOutlets
    @IBOutlet weak var articlesTableView : UITableView!
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        self.articlesTableView.reloadData()
        
        self.navigationItem.title = navTitle

    }
}

// MARK: TableView Methods
extension ArticleFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let articlesFeedCell = tableView.dequeueReusableCell(withIdentifier: FEED_CELL, for: indexPath) as? ArticlesFeedCell else {
            print("!!! Issue with articlesFeedCell.")
            return UITableViewCell()
        }
        articlesFeedCell.selectionStyle = UITableViewCellSelectionStyle.none
        articlesFeedCell.buttonTappedAction = { articlesFeedCell in
            guard let indexPath = tableView.indexPath(for: articlesFeedCell) else { return }
            
            let articleURL = self.articles[indexPath.row].url
            print(">>> line\(#line) ArticleURL: ", articleURL as Any)
            let activityViewController = UIActivityViewController(activityItems: [articleURL as Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        let article = articles[indexPath.row]

        dataSource.downloadImage(from: article.urlToImage!) { (image) in
            articlesFeedCell.articleImage.image = image
        }
        
        articlesFeedCell.articleTitle.text = article.title
        articlesFeedCell.articleInfoLabel.text = article.source?.name
    
        return articlesFeedCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticleIndexPath = indexPath
        performSegue(withIdentifier: FEED_TO_ARTICLE, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleDetailVC = segue.destination as? ArticleDetailViewController {
            if let selectedArticleIndexPath = self.selectedArticleIndexPath {
                articleDetailVC.article = articles[selectedArticleIndexPath.row]
            }
        }
    }
    
}




