
import SwiftUI

struct AddView: View {
    //       @State  var id = ""
    //       @State  var title = ""
    //       @State  var content = ""
    //       @State private var selectedCategoryIndex = 0
    //       @State  var category: String = ""
    //       @State  var tags = ""
    @State private var isShowingImagePicker = false
    @ObservedObject private var viewModel = AddViewModel()
    let categories = [ "News", "Sports","Health","Food"]
    
    @State private var id: String
    @State private var title: String
    @State private var content: String
    @State private var category: String = "News"
    @State private var tags: String
    
    init(id: String, title: String, content: String, category: String, tags: String) {
        self._id = State(initialValue: id)
        self._title = State(initialValue: title)
        self._content = State(initialValue: content)
        self._category = State(initialValue: category)
        self._tags = State(initialValue: tags)
    }
    
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                ZStack{   ScrollView(showsIndicators: false) {
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                    } else {
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            Text("Pick Image")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(10)
                        .padding(.vertical,4)
                    }
                    
                    TextField("Title", text: $title)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.vertical,4)
                    
                    TextField("Content", text: $content)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.vertical, 4)
                    
                    Picker(selection: $category, label: Text("Category")) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical,4)
                    
                    TextField("Tags (Optional)", text: $tags)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.vertical,4)
                            }
                            if viewModel.isLoadingArticles{
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                        }
                        .padding()
                        .navigationBarTitle("Add Article")
                        .navigationBarItems(trailing:
                                                Button("Save") {
                            viewModel.saveArticleToFirestore(title: title, content: content,category: category, tags: [tags])
                        }
                        )
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePickerOR(image: $viewModel.selectedImage, id: id)
                        }
                        .alert(isPresented: $viewModel.alert) {
                            Alert(title: Text("One or more required parameters are empty."), dismissButton: .default(Text("OK")))
                        }
                        .onChange(of: category) { cat in
                            print(cat)
                        }
                        .alert(isPresented: $viewModel.saved) {
                            Alert(title: Text("Saved"), dismissButton: .default(Text("OK")))
                        }
                        .onChange(of: viewModel.saved) { saved in
                            if saved {
                                title = ""
                                content = ""
                                category = ""
                                tags = ""
                                viewModel.selectedImage = nil
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }

                        .onChange(of: viewModel.selectedImage) { newImage in
                            if let image = newImage {
                                viewModel.uploadImage(image, id: viewModel.generateRandomUserID())
                            }
                        }
                    }.navigationBarTitle("Add Blog", displayMode: .large)
                }
                .tabItem {
                    Image(systemName: "plus.app.fill")
                    Text("Add")
                }
        }
    }

//#Preview {
//    AddView()
//}
