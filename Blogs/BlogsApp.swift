import SwiftUI
import FirebaseCore
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      Auth.auth().signInAnonymously { (authResult, error) in
          if let error = error {
              // Handle error
              print("Error signing in anonymously: \(error.localizedDescription)")
              return
          }
          
          // User signed in anonymously
          if let user = authResult?.user {
              // You can access the user's UID using user.uid
              print("User signed in anonymously with UID: \(user.uid)")
          }
      }

    return true
  }
}

@main
struct BlogsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        print("firebase initiazized")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
