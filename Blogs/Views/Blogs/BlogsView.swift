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
                            .onChange(of:  self.viewModel.searchText) { _ in
                            viewModel.filterArticles()
                        }
                        
                        Picker(selection: $viewModel.selectedCatIndex, label: Text("Category:")) {
                            ForEach(viewModel.categoriesOptions.indices, id: \.self) { index in
                                Text(viewModel.categoriesOptions[index])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .onChange(of: viewModel.selectedCatIndex) { _ in
                            viewModel.filterArticlesCatIndex()
                        }
                        
                        
                        if viewModel.isLoadingArticles {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        } else {
                            VStack() {
                            
                                ForEach(viewModel.filteredArticles.indices, id: \.self) { index in
                                    if index >= viewModel.startIndex && index < viewModel.endIndex {
                                            ArticleView(article: viewModel.filteredArticles[index], function: {
                                                viewModel.isLongPress = true
                                                viewModel.selectedArticle = viewModel.filteredArticles[index]
                                            })
                                        }
                                    }
                                
                                if viewModel.filteredArticles.count > 5 {
                                    HStack {
                                        if viewModel.showPrevButton {
                                            HStack{
                                                Image(systemName: "arrow.backward")
                                                Button(action: {
                                                    viewModel.startIndex -= 5
                                                    viewModel.showNextButton = true
                                                    if viewModel.startIndex == 0 {
                                                        viewModel.showPrevButton = false
                                                    }
                                                }) {
                                                    Text("Previous")
                                                        .foregroundColor(.black)
                                                        .bold()
                                                }
                                            }
                                            Spacer()
                                        }
                                        
                                        if viewModel.showNextButton {
                                            Spacer()
                                            HStack{
                                                Button(action: {
                                                    viewModel.startIndex += 5
                                                    viewModel.showPrevButton = true
                                                    if viewModel.startIndex + 5 >= viewModel.articles.count {
                                                        viewModel.showNextButton = false
                                                    }
                                                }) {
                                                    Text("Next")
                                                        .foregroundColor(.black)
                                                        .bold()
                                                }
                                                Image(systemName: "arrow.right")
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                
                            }
                            .padding(.top, 4)
                            .sheet(isPresented: $viewModel.isLongPress) {
                                AddView(id: viewModel.selectedArticle!.id,
                                        title: viewModel.selectedArticle!.title,
                                        imageURL: viewModel.selectedArticle!.imageURL?.absoluteString ?? "",
                                        content: viewModel.selectedArticle!.content,
                                        category: viewModel.selectedArticle!.category,
                                        tags: viewModel.selectedArticle!.tags.first ?? "",edit: true)
                            }.onChange(of:  self.viewModel.isLongPress) { newValue in
                                guard !newValue else { return }
                                viewModel.getArticles()
                                viewModel.selectedCatIndex = 0
                            }
                        }
                    }
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
