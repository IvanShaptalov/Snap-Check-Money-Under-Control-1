import MessageUI


class SettingsScreenViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var result: Result<MFMailComposeResult, Error>? = nil
    @Published var isShowingMailView = false
}
