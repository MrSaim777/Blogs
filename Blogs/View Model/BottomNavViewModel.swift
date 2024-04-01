//
//  BottomNavViewModel.swift
//  Blogs
//
//  Created by Usama Sultan on 30/03/2024.
//

import Foundation

enum Tab {
        case blogs,add, profile
    }

class BottomNavViewModel: ObservableObject {
    @Published var selectedTab: Tab = .blogs
}
