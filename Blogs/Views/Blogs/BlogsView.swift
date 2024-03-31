import SwiftUI

struct BlogsView: View {
    @StateObject private var viewModel = BlogViewModel()
    
    var body: some View {
        NavigationView{ VStack {
            ScrollView {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                Picker(selection: $viewModel.selectedCatIndex, label: Text("Category:")) {
                    ForEach(0 ..< viewModel.categoriesOptions.count) {
                        Text(viewModel.categoriesOptions[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if viewModel.isLoadingArticles {
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                } else {
                    //                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.filteredArticles) { article in
                            ArticleView(article: article)
                        }
                    }
                    .padding()
                    //  ]              }
                }
            }
        }
        .onChange(of: viewModel.searchText) { _ in
            viewModel.filterArticles()
        }
        .onChange(of: viewModel.selectedCatIndex) { _ in
            viewModel.filterArticlesCatIndex()
        }.navigationBarTitle("Blogs", displayMode: .large)
            }.tabItem {
                Image(systemName: "house")
                Text("Home")
            }
    }
}

#Preview {
    BlogsView()
}
