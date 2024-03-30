//
//  BottomNavView.swift
//  Blogs
//
//  Created by Usama Sultan on 30/03/2024.
//

import  SwiftUI

struct BottomNavView: View {
    @ObservedObject var viewModel = BottomNavViewModel()
    var body: some View {
           NavigationView {
               TabView(selection: $viewModel.selectedTab) {
                   BlogsView().tag(Tab.blogs)
                   ProfileView().tag(Tab.profile)
               }
               .accentColor(.red)
               .navigationBarTitle("Blogs", displayMode: .inline)
           }
           
       }
}

#Preview {
    BottomNavView()
}
