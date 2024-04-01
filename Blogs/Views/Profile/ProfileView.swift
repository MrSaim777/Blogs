import Foundation
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    @State private var isShowingImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isFetchingData{
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                }else{
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        if let profileImage = viewModel.profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        } else {
                            if viewModel.imageURL.isEmpty {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            } else {
                                AsyncImage(url: URL(string: viewModel.imageURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        // Placeholder view
                                        ProgressView()
                                               .frame(width: 120, height: 120)
                                               .progressViewStyle(CircularProgressViewStyle())
                                    case .success(let image):
                                        // Loaded image
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                            .shadow(radius: 10)
                                    case .failure(_):
                                        // Error view
                                        Text("Failed to load image")
                                    @unknown default:
                                        // Placeholder view
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(width: 120, height: 120)
                            }

                        }
                    }.padding(.top,20)
                    Form {
                        Section() {
                            TextField("Username", text: $viewModel.username)
                            TextField("Email", text: $viewModel.email)
                            TextField("Phone Number", text: $viewModel.phoneNumber)
                        }
                    }
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .modifier(FormHiddenBackground())
                Spacer()
                }
            }
            .navigationBarTitle("Profile")
            .navigationBarItems(trailing:
                Button(action: {
                viewModel.addUserToFirestore()
                }) {
                    Text("Save")
                }
            )
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $viewModel.profileImage)
            } .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Profile Saved"), dismissButton: .default(Text("OK")))
            }
        }
        .tabItem {
            Image(systemName: "person")
            Text("Profile")
        }
    }
}

struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }
}

//#Preview {
//    ProfileView()
//}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = ProfileViewModel()
//        viewModel.username = "JohnDoe"
//        viewModel.email = "john@example.com"
//        viewModel.phoneNumber = "1234567890"
//
//        return ProfileView(viewModel: viewModel)
//    }
//}
