//
//  ArticleModel.swift
//  Blogs
//
//  Created by Usama Sultan on 30/03/2024.
//

import Foundation

struct Article: Identifiable {
    var id: String
    var title: String
    var content: String
    var author: String
    var category: String
    var tags: [String]
    var imageURL: URL?
//    var isPublished: Bool
    
//    init(title: String, content: String, author: String, category: String, tags: [String], imageURL: URL? = nil, isPublished: Bool = false) {
//        self.title = title
//        self.content = content
//        self.author = author
//        self.category = category
//        self.tags = tags
//        self.imageURL = imageURL
//        self.isPublished = isPublished
//    }
}


