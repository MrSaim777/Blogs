import  SwiftUI

struct BottomNavView: View {
    @ObservedObject var viewModel = BottomNavViewModel()
    var body: some View {
               TabView(selection: $viewModel.selectedTab) {
                   BlogsView().tag(Tab.blogs)
                   AddView(id: "",title: "",imageURL: "" , content: "", category: "", tags: "",edit: false).tag(Tab.add)
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
