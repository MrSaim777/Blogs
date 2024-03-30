import SwiftUI

struct BlogsView: View {
    @StateObject private var viewModel = BlogViewModel()
    
    var body: some View {
            VStack {
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
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.filteredArticles) { article in
                            ArticleView(article: article)
                        }
                    }
                    .padding()
                }
            }.onChange(of: viewModel.searchText, perform: { _ in
                viewModel.filterArticles()
            }).onChange(of: viewModel.selectedCatIndex, perform: { _ in
                viewModel.filterArticlesCatIndex()
            }).tabItem {
                Image(systemName: "house")
                Text("Home")
            }
    }
}

#Preview {
    BlogsView()
}
