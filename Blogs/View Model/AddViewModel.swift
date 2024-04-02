import Foundation
import SwiftUI
import FirebaseStorage
import Firebase

class AddViewModel: ObservableObject{
    
    @Published var selectedImage: UIImage?
    @Published var imageURL: String = ""
    @Published var isLoadingArticles = false
    @Published var alert = false
    @Published var saved = false
    @Published var deleted = false
    @Published var isDeleted = false
    
    
    
    func generateRandomUserID() -> String {
        let uuid = UUID().uuidString
        let randomNumber = String(format: "%04d", Int.random(in: 1000...9999))
        let userID = "\(uuid)-\(randomNumber)"
        return userID
    }
    
    func uploadImage(_ image: UIImage, id: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(id).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uploadTask = imageRef.putData(imageData, metadata: metadata)

        uploadTask.observe(.success) { snapshot in
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                guard let downloadURL = url else {
                    print("Download URL not found")
                    return
                }
                self.imageURL = downloadURL.absoluteString
                print("Uploaded: \(self.imageURL)")
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Image upload failed: \(error.localizedDescription)")
            }
        }
    }
    
    func saveArticleToFirestore(title: String, content: String, category: String, tags: [String]) {
        guard !title.isEmpty, !content.isEmpty, !category.isEmpty, !imageURL.isEmpty else {
            print("Error: One or more required parameters are empty.")
            self.alert = true
            return
        }

        addBlogArticle(title: title, content: content, category: category, tags: tags, imageURL: imageURL) { documentID in
            if let documentID = documentID {
                self.saved = true
                print("Article added with document ID: \(documentID)")
            } else {
                print("Failed to add article.")
            }
        }
    }

    
    func addBlogArticle(title: String, content: String, category: String, tags: [String], imageURL: String, completion: @escaping (String?) -> Void) {
        isLoadingArticles = true

        let articleRef = Firestore.firestore().collection("articles").document()

        let articleData: [String: Any] = [
            "id": articleRef.documentID,
            "title": title,
            "content": content,
            "author": "",
            "category": category,
            "tags": tags,
            "imageURL": imageURL
        ]
        
        articleRef.setData(articleData) { error in
            self.isLoadingArticles = false

            if let error = error {
                print("Error adding document: \(error)")
                completion(nil)
            } else {
                print("Document added with ID: \(articleRef.documentID)")

                completion(articleRef.documentID)

            }
        }
    }
    
    func updateBlogArticle(articleID: String, title: String, content: String, category: String, tags: [String], imageURL: String) {
        isLoadingArticles = true

        let articleRef = Firestore.firestore().collection("articles").document(articleID)

        let updatedData: [String: Any] = [
            "title": title,
            "content": content,
            "category": category,
            "tags": tags,
            "imageURL": self.imageURL == "" ? imageURL : self.imageURL
        ]

        articleRef.updateData(updatedData) { error in
            self.isLoadingArticles = false

            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated with ID: \(articleID)")
                self.saved = true
            }
        }
    }
    
    func deleteBlogArticle(articleID: String) {
        isLoadingArticles = true
        
        let articleRef = Firestore.firestore().collection("articles").document(articleID)
        
        articleRef.delete { error in
            self.isLoadingArticles = false
            
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                self.deleted = true
                print("Document deleted with ID: \(articleID)")
            }
        }
    }


}
