import SwiftUI
// Paywall View
struct PaywallView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Upgrade to Pro")
                    .font(.largeTitle)
                    .padding()
                
                Text("Unlock all features for just $4.99/month.")
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
            .navigationTitle("Subscription")
        }
    }
}
