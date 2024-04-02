import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore


class ProfileViewModel: ObservableObject {
    @Published var id = ""
    @Published var username = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var imageURL = ""
    @Published var profileImage: UIImage? = nil
    @Published var showAlert = false
    @Published var isFetchingData = false
    
    init(id: String = "", username: String = "", email: String = "", phoneNumber: String = "", profileImage: UIImage? = nil, showAlert: Bool = false) {
        self.id = self.getUID()
        self.username = username
        self.email = email
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
        self.showAlert = showAlert
        self.retrieveUserDataFromFirestore()
    }

    func getUID() -> String {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            print("User is not signed in")
            return ""
        }
    }

    func addUserToFirestore() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(self.id)
        
        let userData: [String: Any] = [
            "id": self.id,
            "username": self.username,
            "email": self.email,
            "phone": self.phoneNumber,
            "imageURL": self.imageURL
        ]
        
        userRef.setData(userData) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error)")
            } else {
                self.showAlert = true
                print("User added to Firestore successfully")
            }
        }
    }
    
    func retrieveUserDataFromFirestore() {
        self.isFetchingData = true
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(self.id)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error retrieving user data: \(error)")
                self.isFetchingData = false
            } else if let document = document, document.exists {
                if let data = document.data() {
                    if let username = data["username"] as? String {
                        self.username = username
                    }
                    if let email = data["email"] as? String {
                        self.email = email
                    }
                    if let phoneNumber = data["phone"] as? String {
                        self.phoneNumber = phoneNumber
                    }
                    if let imageURLString = data["imageURL"] as? String, let _ = URL(string: imageURLString) {
                        self.imageURL = imageURLString
                    }
                }
                self.isFetchingData = false
            } else {
                print("User document does not exist")
                self.isFetchingData = false
            }
        }
    }

}
