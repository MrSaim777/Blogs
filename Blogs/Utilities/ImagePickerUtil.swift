import SwiftUI
import Firebase
import FirebaseStorage

class ImageUploader: ObservableObject {
    @Published var imageURL: URL?
//    @Published var uploadProgress: Double = 0.0
    
    func getUID() -> String {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            print("User is not signed in")
            return ""
        }
    }
    
    
    func updateImageURLInFirestore(newImageURL: URL,id: String) {
         let db = Firestore.firestore()
         let userRef = db.collection("users").document(id)

         userRef.updateData(["imageURL": newImageURL.absoluteString]) { error in
             if let error = error {
                 print("Error updating image URL in Firestore: \(error)")
             } else {
                 print("Image URL updated in Firestore successfully")
             }
         }
     }

    
//    func addImageToFirestore(imageURL: String,uid: String) {
//        let db = Firestore.firestore()
//        let userRef = db.collection("users").document(uid)
//
//        let profileViewModel = ProfileViewModel()
//
//        var userData: [String: Any] = [
//            "imageURL": ""
//        ]
//
//        userRef.setData(userData) { error in
//            if let error = error {
//                print("Error adding user to Firestore: \(error)")
//            } else {
//                profileViewModel.showAlert = true
//                print("User added to Firestore successfully")
//            }
//        }
//    }

    func uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let uid = getUID()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(uid).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uploadTask = imageRef.putData(imageData, metadata: metadata)

        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
//            self.uploadProgress = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
        }

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
                self.updateImageURLInFirestore(newImageURL: downloadURL, id: uid)
                self.imageURL = downloadURL
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Image upload failed: \(error.localizedDescription)")
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                let imageUploader = ImageUploader()
                imageUploader.uploadImage(uiImage)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

