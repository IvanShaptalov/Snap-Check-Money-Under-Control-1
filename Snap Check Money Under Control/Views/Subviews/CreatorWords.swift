import SwiftUI


struct CreatorWords: View {
    var body: some View {
        VStack {
            Text("made with ☕️ & ❤️")
                .font(.system(size: 20, weight: .semibold))
            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "v 1.0")
                .font(.system(size: 20, weight: .semibold))
        }
        .padding()
        
    }
}

