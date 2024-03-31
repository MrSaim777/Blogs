import Foundation

struct Article: Identifiable {
    var id: String
    var title: String
    var content: String
    var author: String
    var category: String
    var tags: [String]
    var imageURL: URL?
}


