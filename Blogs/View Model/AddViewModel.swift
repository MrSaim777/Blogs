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
        // Set loading state to true while adding the article
        isLoadingArticles = true

        // Create a reference to the Firestore collection where articles are stored
        let articleRef = Firestore.firestore().collection("articles").document()

        // Create data dictionary to be added to Firestore
        let articleData: [String: Any] = [
            "id": articleRef.documentID,
            "title": title,
            "content": content,
            "author": "",
            "category": category,
            "tags": tags,
            "imageURL": imageURL
        ]
        

        // Add the data to Firestore
        articleRef.setData(articleData) { error in
            // Set loading state to false after adding the article
            self.isLoadingArticles = false

            if let error = error {
                // Handle the error
                print("Error adding document: \(error)")
                completion(nil) // Call completion handler with nil to indicate failure
            } else {
                // Article added successfully
                print("Document added with ID: \(articleRef.documentID)")

                // Call completion handler with document ID
                completion(articleRef.documentID)

//                BlogViewModel().getArticles()
            }
        }
    }

}
