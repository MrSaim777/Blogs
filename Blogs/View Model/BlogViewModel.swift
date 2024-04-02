import Foundation
import SwiftUI
import Firebase

class BlogViewModel: ObservableObject {
    @Published  var selectedFilterIndex = 0
    @Published  var selectedCatIndex = 0
    @Published var articles: [Article] = []
    @Published var filteredArticles: [Article] = []
    @Published var searchText: String = ""
    // Add more properties as needed for user metadata, authentication, etc.
    let categoriesOptions = ["All", "News", "Sports","Health","Food"]
    let filterOptions = ["Title", "Auther", "Content"]
    let db = Firestore.firestore()
    let articleCollection = Firestore.firestore().collection("articles");
    @Published var isLoadingArticles = false
    
    init() {
        self.getArticles()
    }
    
//    func addBlogArticle(title: String, content: String, author: String, category: String, tags: [String], imageURL: URL?) {
//        isLoadingArticles = true
//        let articleRef = Firestore.firestore().collection("articles").document()
//
//        var articleData: [String: Any] = [
//            "id": articleRef.documentID,
//            "title": title,
//            "content": content,
//            "author": author,
//            "category": category,
//            "tags": tags
//        ]
//
//        if let imageURL = imageURL {
//            articleData["imageURL"] = imageURL.absoluteString
//        }
//
//        articleRef.setData(articleData) { error in
//            self.isLoadingArticles = false
//            if let error = error {
//                print("Error adding document: \(error)")
//            } else {
//                print("Document added with ID: \(articleRef.documentID)")
//                self.getArticles()
//            }
//        }
//    }

    
    func getArticles() {
            isLoadingArticles = true
            articleCollection.getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                defer {
                    self.isLoadingArticles = false
                }
                
                if let error = error {
                    // Handle the error
                    print("Error getting documents: \(error)")
                    return
                }
                
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.articles = snapshot.documents.compactMap { document in
                            guard
//                                   let id = document.documentID as? String,
                                   let title = document["title"] as? String,
                                   let content = document["content"] as? String,
                                   let author = document["author"] as? String,
                                   let category = document["category"] as? String,
                                   let tags = document["tags"] as? [String]
                               else {
                                   return nil
                               }

                               // Create Article instance using retrieved data
                               let imageURL = document["imageURL"] as? String
                               let imageURLURL = imageURL.flatMap { URL(string: $0) }
                               
                               return Article(
                                id: document.documentID,
                                title: title,
                                content: content,
                                author: author,
                                category: category,
                                tags: tags,
                                imageURL: imageURLURL
                            )
                        }
                        self.filteredArticles = self.articles
                    }
                }
            }
        }
    
       
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
        case 3:
            filteredArticles = articles.filter { article in
                article.category.localizedCaseInsensitiveContains(categoriesOptions[3])
                
            }
        case 4:
            filteredArticles = articles.filter { article in
                article.category.localizedCaseInsensitiveContains(categoriesOptions[4])
            }
        default:
            break
        }
    }
}
