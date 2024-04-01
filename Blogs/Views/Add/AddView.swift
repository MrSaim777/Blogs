
import SwiftUI

struct AddView: View {
    var body: some View {
        NavigationView {
         
        } .navigationBarTitle("Add Blog", displayMode: .large)
        .tabItem {
            Image(systemName: "plus.app.fill")
            Text("Add")
        }
    }
}

#Preview {
    AddView()
}
