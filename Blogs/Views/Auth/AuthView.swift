//
//  AuthView.swiftimport Foundation
import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel = AuthViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        if viewModel.isInitialized==true{
                    if viewModel.isAuthenticated {
                        BottomNavView()
                    } else {
                       AuthFailedView()
                    }
            } else {
                ProgressView()
                    .onAppear {
                        viewModel.authenticate()
                    }
            }
    }
}

#Preview {
    AuthView()
}
