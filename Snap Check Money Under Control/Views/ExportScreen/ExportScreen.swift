import SwiftUI
// Paywall View
struct ExportScreen: View {
    var body: some View {
        VStack {
            Text("Export")
                .font(.largeTitle)
                .padding()
            
            Text("Unlock all features for just $40000.99/month.")
                .padding()
            
            Button("Subscribe Now") {
                // Handle subscription logic here
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
        }
    }
}
