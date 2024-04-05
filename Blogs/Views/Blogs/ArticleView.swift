import SwiftUI

struct ArticleView: View {
    var article: Article
    var function: () -> Void

    var body: some View {
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
                    self.function()
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
}
