import Foundation
import SwiftUI


struct FloatingActionButton: View {
    @Binding var showActionSheet: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                showActionSheet = true // Trigger action sheet
            }
        }) {
            Image(systemName: "plus") // Use a "+" icon
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle()) // Make it circular
                .shadow(radius: 5) // Optional shadow for elevation
        }
    }
}
