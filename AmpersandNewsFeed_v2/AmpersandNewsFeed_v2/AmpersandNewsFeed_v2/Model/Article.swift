//
//  Article.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 3/5/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//


import Foundation

struct Root: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}

