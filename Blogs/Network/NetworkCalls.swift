import Firebase

struct NetworkCalls{
    func anonymousSignIn(){
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
                return
            }
            if let user = authResult?.user {
                print("User signed in anonymously with UID: \(user.uid)")
            }
        }
    }
    
}
