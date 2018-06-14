//
//  Category.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 1/22/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import Foundation

class Category {
    
    let categoryQuery: String
    let categoryTitle: String
    
    init(categoryQuery: String, categoryTitle: String) {
        self.categoryQuery = categoryQuery
        self.categoryTitle = categoryTitle
    }

    static var categories = [
        Category(categoryQuery: "general", categoryTitle: "LATEST"),
        Category(categoryQuery: "technology", categoryTitle: "TECHNOLOGY"),
        Category(categoryQuery: "science", categoryTitle: "SCIENCE & NATURE"),
        Category(categoryQuery: "business", categoryTitle: "BUSINESS"),
        Category(categoryQuery: "entertainment", categoryTitle: "ENTERTAINMENT"),
        Category(categoryQuery: "sports", categoryTitle: "SPORTS")
    ]
}

