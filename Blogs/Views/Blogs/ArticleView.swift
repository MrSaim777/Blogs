import SwiftUI

struct ArticleView: View {
    var article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                if let imageURL = article.imageURL {
                    AsyncImage(url: imageURL) 
                    { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(8)
                    } placeholder: {
                        Color.gray
                            .frame(height: 200)
                            .cornerRadius(8)
                    }
                }
            Text(article.title)
                .font(.title)
                .fontWeight(.bold)
//            Text("By \(article.author) • \(article.publicationDate)")
//                .foregroundColor(.gray)
            Text(article.content)
//                .lineLimit(3)
                .font(.body)
                .foregroundColor(.secondary)
            HStack {
                ForEach(article.tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
