//
//  BlogViewModel.swift
//  Blogs
//
//  Created by Usama Sultan on 30/03/2024.
//

import Foundation
import SwiftUI

class BlogViewModel: ObservableObject {
    @Published  var selectedFilterIndex = 0
    @Published  var selectedCatIndex = 0
    @Published var articles: [Article] = []
    @Published var filteredArticles: [Article] = []
    @Published var searchText: String = ""
    // Add more properties as needed for user metadata, authentication, etc.
    let categoriesOptions = ["All", "Trending", "Latest"]
    let filterOptions = ["Title", "Auther", "Content"]
    
    enum Cat{
       case latest,trending,news
    }
    
    init() {
        self.articles = [
            Article(title: "New modalities in models for healthcare", content: "Medicine is a multimodal discipline; it’s made up of different types of information stored across formats — like radiology images, lab results, genomics data, environmental context and more. To get a fuller understanding of a person’s health, we need to build technology that understands all of this information.We’re bringing new capabilities to our models with the hope of making generative AI more helpful to healthcare organizations and people’s health. We just introduced MedLM for Chest X-ray, which has the potential to help transform radiology workflows by helping with the classification of chest X-rays for a variety of use cases. We’re starting with Chest X-rays because they are critical in detecting lung and heart conditions. MedLM for Chest X-ray is now available to trusted testers in an experimental preview on Google Cloud.", author: "Usama Sultan", publicationDate: Date(), category: "Latest", tags: ["Latest", "AI","Health"], imageURL: URL(string: "https://cdn.pixabay.com/photo/2015/05/31/10/55/man-791049_640.jpg")),
            Article(title: "Title 2", content: "Content 2", author: "Author 2", publicationDate: Date(), category: "Latest", tags: ["Tag1", "Tag3"]),
            Article(title: "Title 1", content: "Content 1", author: "Author 1", publicationDate: Date(), category: "News", tags: ["Tag1", "Tag2"], imageURL: URL(string: "https://cdn.pixabay.com/photo/2015/05/31/10/55/man-791049_640.jpg")),
            Article(title: "Title 2", content: "Content 2", author: "Author 2", publicationDate: Date(), category: "Trending", tags: ["Tag1", "Tag3"]),
        ]
        self.filteredArticles = articles
    }

    // Function to filter articles based on search text
    func filterArticles() {
        if searchText.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter { article in
                article.title.localizedCaseInsensitiveContains(searchText)
               ||
                article.content.localizedCaseInsensitiveContains(searchText)
                ||
                article.author.localizedCaseInsensitiveContains(searchText)
                ||
                article.category.localizedCaseInsensitiveContains(searchText)
                ||
                article.tags.contains { $0.localizedCaseInsensitiveContains(searchText)}
            }
        }
    }
    
    func filterArticlesFilterIndex(selectedFilterIndex: Int) {
        if searchText.isEmpty {
            filteredArticles = articles
        } else {
            switch selectedFilterIndex {
            case 0: // Filter by title
                filteredArticles = articles.filter { article in
                    article.title.localizedCaseInsensitiveContains(searchText)
                }
            case 1: // Filter by content
                filteredArticles = articles.filter { article in
                    article.content.localizedCaseInsensitiveContains(searchText)
                }
            case 2: // Filter by tags
                filteredArticles = articles.filter { article in
                    article.tags.contains { tag in
                        tag.localizedCaseInsensitiveContains(searchText)
                    }
                }
            default:
                break
            }
        }
    }
    
    func filterArticlesCatIndex() {
        switch selectedCatIndex {
        case 0:
            filteredArticles = articles
        case 1:
            filteredArticles = articles.filter { article in
                article.category.localizedCaseInsensitiveContains(categoriesOptions[1])
            }
        case 2:
            filteredArticles = articles.filter { article in
                article.category.localizedCaseInsensitiveContains(categoriesOptions[2])
            }
        default:
            break
        }
    }
}
