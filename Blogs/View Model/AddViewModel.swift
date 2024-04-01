import Foundation
import SwiftUI
import FirebaseStorage

class AddViewModel: ObservableObject{
    
    @Published var selectedImage: UIImage?
    @Published var imageURL: String = ""
   
    
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
}
