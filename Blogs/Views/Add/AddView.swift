
import SwiftUI

struct AddView: View {
       @State private var id = ""
       @State private var title = ""
       @State private var content = ""
       @State private var selectedCategoryIndex = 0
       @State private var category: String = ""
       @State private var tags = ""
//       @State private var selectedImage: UIImage?
       @State private var isShowingImagePicker = false
    
    @ObservedObject var viewModel = AddViewModel()
    
    let categories = [ "News", "Sports","Health","Food"]



    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                ScrollView(showsIndicators: false) {
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
            
            Picker("Category", selection: $selectedCategoryIndex) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Text(categories[index])
                }
            }
//            Picker(selection: $category, label: Text("Category")) {
//               ForEach(categories, id: \.self) {
//                   Text($0)
//               }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical,4)

            TextField("Tags", text: $tags)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.vertical,4)
        }
        .padding()
        .navigationBarTitle("Add Article")
        .navigationBarItems(trailing:
                      Button("Save") {
//                          saveArticle()
                      }
                  )
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerOR(image: $viewModel.selectedImage, id: id)
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

#Preview {
    AddView()
}
