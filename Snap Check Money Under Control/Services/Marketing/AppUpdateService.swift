import SwiftUI

@MainActor
class UpdateChecker: ObservableObject {
    @Published var isUpdateAvailable: Bool = false
    @Published var errorMessage: String?
    
    func checkForUpdate() async {
        let timestamp = Int(Date().timeIntervalSince1970) // Текущая метка времени
        do {
            guard let info = Bundle.main.infoDictionary,
                  let currentVersion = info["CFBundleShortVersionString"] as? String,
                  let identifier = info["CFBundleIdentifier"] as? String,
                  let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)&timestamp=\(timestamp)") else {
                NSLog("🧐 version check > error while creating url")
                isUpdateAvailable = false
                return
            }
            print("indent")
            print(identifier)
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
            
            guard let result = (json?["results"] as? [Any])?.first as? [String: Any],
                  let version = result["version"] as? String else {
                NSLog("🧐 version check > error while parsing results")
                isUpdateAvailable = false
                return
            }
            
            // Обновляем состояние isUpdateAvailable на основе сравнения версий
            NSLog("🧐 version check > \(version) != \(currentVersion)")
            isUpdateAvailable = version != currentVersion
            
            
        } catch {
            NSLog("🧐 version check > error: \(error.localizedDescription)")
            isUpdateAvailable = false
        }
    }
}
