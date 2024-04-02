
import SwiftUI

struct AddView: View {
    @State private var isShowingImagePicker = false
    @ObservedObject private var viewModel = AddViewModel()
    
    
    let categories = [ "News", "Sports","Health","Food"]

    @State  var id: String
    @State  var title: String
    @State  var imageURL: String
    @State  var content: String
    @State  var category: String
    @State  var tags: String
    var edit: Bool
    
    @Environment(\.dismiss) var dismiss
    
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
                        if self.edit{
                            AsyncImage(url: URL(string: viewModel.imageURL)) { phase in
                                switch phase {
                                case .empty:
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
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 100).frame(width: 120, height: 120)
                                case .failure(_):
                                    Text("Failed to load image")
                                @unknown default:
                                    ProgressView()
                                           .frame(width: 120, height: 120)
                                           .progressViewStyle(CircularProgressViewStyle())
                                }
                            }
                            
                        }else{
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
                        .navigationBarTitle("Add Blog")
                        .navigationBarItems(trailing:
                            Group {
                                if self.edit {
                                    HStack {
                                        Button(action: {
                                            viewModel.isDeleted = true
                                        }) {
                                            Text("Delete").foregroundColor(.red)
                                        }.alert(isPresented: $viewModel.isDeleted) {
                                            Alert(title: Text("Confirm Deletion"),
                                                message: Text("Are you sure you want to delete ?"),
                                                primaryButton: .destructive(Text("Delete")) {
                                                viewModel.deleteBlogArticle(articleID: id)
                                                dismiss()
                                                },
                                                secondaryButton: .cancel())
                                        }
                                        
                                        Button(action: {
                                            viewModel.updateBlogArticle(articleID: id, title: title, content: content, category: category, tags: [tags], imageURL: imageURL)
                                        }) {
                                            Text("Update")
                                        }.alert(isPresented: self.viewModel.saved && !self.edit ? Binding.constant(true) : Binding.constant(false)) {
                                            Alert(title: Text("Updated"), dismissButton: .default(Text("OK")))
                                        }
                                    }
                                } else {
                                    Button(action: {
                                        viewModel.saveArticleToFirestore(title: title, content: content, category: category, tags: [tags])
                                    }) {
                                        Text("Save")
                                    }.alert(isPresented: self.viewModel.saved && !self.edit ? Binding.constant(true) : Binding.constant(false)) {
                                        Alert(title: Text("Saved"), dismissButton: .default(Text("OK")))
                                    } 
//                                    .alert(isPresented: $viewModel.alert) {
//                                        Alert(title: Text("One or more required parameters are empty."), dismissButton:           .default(Text("OK")))
//                                    }
                                }
                            }
                        )
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePickerOR(image: $viewModel.selectedImage, id: id)
                        }
                        .onChange(of: category) { cat in
                            print(cat)
                        }
                        .onChange(of: viewModel.saved) { saved in
                            if saved {
                                title = ""
                                content = ""
                                category = ""
                                tags = ""
                                viewModel.selectedImage = nil
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                if self.edit {
                                    dismiss()
                                }
                            }
                        }

                        .onChange(of: viewModel.selectedImage) { newImage in
                            if let image = newImage {
                                viewModel.uploadImage(image, id: viewModel.generateRandomUserID())
                            }
                        }
                    }
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
