import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

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
