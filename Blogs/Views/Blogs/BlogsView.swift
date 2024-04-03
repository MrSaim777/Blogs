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
//                                ArticleView(article: article).onTapGesture{
//                                    viewModel.isLongPress = true
//                                    viewModel.selectedArticle = article
//                                }
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    if let imageURL = article.imageURL {
                                        AsyncImage(url: imageURL) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 310)
                                                .frame(height: 200)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray
                                                .frame(width: 310)
                                                .frame(height: 200)
                                                .cornerRadius(8)
                                        }
                                        .clipped()
                                    }
                                    Text(article.title)
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text(article.content)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        ForEach(article.tags, id: \.self) { tag in
                                            Text("#\(tag)")
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.black)
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            viewModel.isLongPress = true
                                            viewModel.selectedArticle = article
                                        }) {
                                            Text("Edit").foregroundColor(.black).bold()
                                        }
                                    }
                                    .padding(.top, 4)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .frame(width: 310, alignment: .center)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                .padding(.vertical, 8)
                               
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
                        tags: viewModel.selectedArticle!.tags.first ?? "",edit: true)
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
