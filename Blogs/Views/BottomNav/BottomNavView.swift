import  SwiftUI

struct BottomNavView: View {
    @ObservedObject var viewModel = BottomNavViewModel()
//    let viewModel = ProfileViewModel()
//    viewModel.username = "JohnDoe"
//    viewModel.email = "john@example.com"
//    viewModel.phoneNumber = "1234567890"
    var body: some View {
        
               TabView(selection: $viewModel.selectedTab) {
                   BlogsView().tag(Tab.blogs)
                   ProfileView().tag(Tab.profile)
               }
               .tint(.black)
                      .onAppear {
                          let tabBarAppearance = UITabBarAppearance()
                          tabBarAppearance.backgroundColor = .white
                          UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                      }
    
           
       }
}

#Preview {
    BottomNavView()
}
