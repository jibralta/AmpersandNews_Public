//
//  ArticleDetailViewController.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 1/22/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController, WKUIDelegate {

    // MARK: Properties
    var article: Article!
    var navTitle = String()

    var webView: WKWebView!
    
    // MARK: IBOutlets
    @IBOutlet weak var articleWebKit: WKWebView!
    
    // MARK: Override Methods
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = navTitle
        
        guard let url = URL(string: self.article.url!) else { return }
            let request = URLRequest(url: url)
            
            DispatchQueue.main.async {
                self.webView.load(request)
            }

        navigationItem.title = article.source?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "shareIcon_44"), style: .plain, target: self, action: #selector(handleShare))
    }

    @objc func handleShare() {
        print("Sharing url")

        guard let articleURL = self.article.url else { return }
        let activityViewController = UIActivityViewController(activityItems: [articleURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true, completion: nil)
    }
    
}


