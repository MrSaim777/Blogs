//
//  HomeView.swift
//  Blogs
//
//  Created by Usama Sultan on 30/03/2024.
//

import Foundation
import SwiftUI

struct BlogsView: View {
    var body: some View {
        VStack(content: {
            Text("Blogs screen")
            
        })
        .tabItem {
            Image(systemName: "house")
            Text("Home")
        }
        
    }
}

#Preview {
    BlogsView()
}
