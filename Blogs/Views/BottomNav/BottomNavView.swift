import  SwiftUI

struct BottomNavView: View {
    @ObservedObject var viewModel = BottomNavViewModel()
    var body: some View {
           NavigationView {
               TabView(selection: $viewModel.selectedTab) {
                   BlogsView().tag(Tab.blogs)
                   ProfileView().tag(Tab.profile)
               }
               .navigationBarTitle("Blogs", displayMode: .large)
               .tint(.black)
                      .onAppear {
                          let tabBarAppearance = UITabBarAppearance()
                          tabBarAppearance.backgroundColor = .tertiarySystemFill
                          UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                      }
           }
           
       }
}

#Preview {
    BottomNavView()
}
