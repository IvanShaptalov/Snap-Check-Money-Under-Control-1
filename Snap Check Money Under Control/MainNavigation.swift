import SwiftUI

struct MainNavigation: View {
    @State private var selectedTab = 0
    @State private var isOnboardingCompleted = UserOnboarder.isWelcomeOnboarded()
    
    var body: some View {
        VStack {
            Spacer()
            if isOnboardingCompleted  {
                // Switch between views based on the selected tab
                switch selectedTab {
                case 0:
                    HomeScreen()
                case 1:
                    ExportScreen()
                case 2:
                    SettingsScreen()
                default:
                    HomeScreen()
                }
                
                Spacer()
                
                // Bottom Navigation Bar
                HStack {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            Image(systemName: "house").imageScale(.large)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        selectedTab = 2
                    }) {
                        VStack {
                            Image(systemName: "gear").imageScale(.large)
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
            } else {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .overlay(
            UpdateActionSheet()
        )
        
    }
}
