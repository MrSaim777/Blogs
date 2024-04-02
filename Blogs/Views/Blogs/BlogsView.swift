import SwiftUI

struct BlogsView: View {
    @ObservedObject  var viewModel = BlogViewModel()
    
    var body: some View {
        NavigationView{
            VStack(spacing: 30) {
                ScrollView(showsIndicators: false) {
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
                        VStack() {
                            ForEach(viewModel.filteredArticles) { article in
                                ArticleView(article: article).onTapGesture{
                                    viewModel.isLongPress = true
                                    viewModel.selectedArticle = article
                                }
                               
                            }
                        }.padding(.top, 4)
                    }
                }
            }.sheet(isPresented: $viewModel.isLongPress) {
                AddView(id: viewModel.selectedArticle!.id,
                        title: viewModel.selectedArticle!.title,
                        imageURL: viewModel.selectedArticle!.imageURL?.absoluteString ?? "",
                        content: viewModel.selectedArticle!.content,
                        category: viewModel.selectedArticle!.category,
                        tags: "",edit: true)
            }
        .onChange(of: viewModel.searchText) { _ in
            viewModel.filterArticles()
        }
        .onChange(of: viewModel.selectedCatIndex) { _ in
            viewModel.filterArticlesCatIndex()
        }
        .onChange(of: viewModel.isLongPress) { newValue in
            guard !newValue else { return }
            viewModel.getArticles()
            viewModel.selectedCatIndex = 0
        }.navigationBarTitle("Blogs", displayMode: .large)
            }.tabItem {
                Image(systemName: "house")
                Text("Blogs")
            }
    }
}

#Preview {
    BlogsView()
}
