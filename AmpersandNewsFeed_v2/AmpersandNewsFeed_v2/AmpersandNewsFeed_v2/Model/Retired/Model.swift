//
//  Model.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 3/18/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import Foundation


struct ArticleX: Codable {
    
    struct Source: Codable {
        let id: String
        let name: String
    }
    
    let source: Source
    let author: String
    let title: String?
    let summary: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?

}
