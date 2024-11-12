//
//  UpdateOverlay.swift
//  visionToText
//
//  Created by PowerMac on 06.11.2024.
//

import SwiftUI

struct UpdateActionSheet: View {
    @Environment(\.openURL) private var openURL
    @StateObject private var updateChecker = UpdateChecker()
    @Environment(\.colorScheme) var colorScheme
    
    
    // Определение цвета тени в зависимости от темы
    private var shadowColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.8) : Color.black.opacity(0.3)
    }
    
    private var overlayColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.8) : Color.black.opacity(0.3)
    }
    
    private func onCancelAction() {
        updateChecker.isUpdateAvailable = false
            // Вставьте здесь код, который должен выполняться при отмене
            NSLog("Update was canceled")
            // Можно добавить другие действия, такие как изменение состояния
    }
    
    var body: some View {
        EmptyView()
            .task {
                await updateChecker.checkForUpdate()
            }
            .actionSheet(isPresented: $updateChecker.isUpdateAvailable) {
                ActionSheet(
                    title: Text("Update Available"),
                    message: Text("A new version of the app is available. Would you like to update?"),
                    buttons: [
                        .default(Text("Update Now")) {
                            openURL(AppConfig.appURL)
                        },
                        .cancel(Text("Later")) {
                            onCancelAction()
                        }
                    ]
                )
                
            }
            .task {
                await updateChecker.checkForUpdate()
            }
    }
}
