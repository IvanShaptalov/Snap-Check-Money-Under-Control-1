import SwiftUI


struct AppLinks: View {
    let url: URL
    let imageName: String
    let title: String
    var body: some View {
        Link(destination: url, label: {
            HStack{
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            
        })
        .foregroundStyle(Color(.label))
    }
}

