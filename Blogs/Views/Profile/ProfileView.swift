//
//  ProfileView.swift
//  Blogs
//
//  Created by Usama Sultan on 30/03/2024.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Profile Screen")
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            
    }
}

#Preview {
    ProfileView()
}
