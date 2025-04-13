import Foundation
import SwiftUI


struct FloatingActionButton: View {
    @Binding var showActionSheet: Bool
    var imageName: String = "plus"
    
    var body: some View {
        Button(action: {
            withAnimation {
                showActionSheet = true // Trigger action sheet
            }
        }) {
            Image(systemName: imageName) // Use a "+" icon
                .font(.title3)
                .frame(width: 28, height: 28)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle()) // Make it circular
                .shadow(radius: 5) // Optional shadow for elevation
        }
    }
}
