import SwiftUI
import MessageUI


struct SettingsScreen: View {
    
    @StateObject var viewModel = SettingsScreenViewModel()
    @Environment(\.openURL) private var openURL
    @State private var showingPaywall = false // State variable to control the paywall
    @State private var showingCategories = false
    @State private var showPrivacyPolicy = false
    @State private var showPromoCodeMenu = false
    @State private var showWishKit = false
    @State private var selectedCurrency: Currency = AppConfig.mainCurrency {
        didSet {
            AnalyticsManager.shared.logEvent(eventType: .currencyChanged)
            AppConfig.updateMainCurrency(to: selectedCurrency)
            NSLog("Selected currency changed to: \(selectedCurrency.rawValue)") // Debugging NSLog
        }
    }
    
    var body: some View {
        
        VStack {
            VStack(spacing: 20) {
                
                List {
                    
                    Section(header: Text("Pro Version")) {
                        SectionButton(title: "Manage subscription") {
                            showingPaywall.toggle() // Open paywall when tapped
                        }
                        
                        SectionButton(title: "Promocodes") {
                            showPromoCodeMenu = true
                        }
                    }
                    
                    
                    Section(header: Text("App Configuration")) {
                        Picker("Currency", selection: $selectedCurrency) {
                            ForEach(Currency.allCases, id: \.self) { currency in
                                Text(currency.description)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: selectedCurrency) { _,newValue in
                            NSLog("Picker selection changed to: \(newValue.description)") // Debugging NSLog
                            selectedCurrency = newValue
                        }
                        
                        
                        Toggle("Show Year Format", isOn: Binding(
                            get: { AppConfig.showYearFormat },
                            set: { _ in
                                AppConfig.toggleIsShowYearFormat() }
                        ))
                        
                        SectionButton(title: "Expense Categories") {
                            showingCategories = true
                        }
                    }
                    
                    Section(header: Text("Feedback")) {
                        
                        SectionButton(title: "Feature Requests") {
                            showWishKit = true
                        }
                        
                        SectionButton(title: "Rate Snap Check") {
                            openURL(AppConfig.appURL)
                            AnalyticsManager.shared.logEvent(eventType: .rateDirectlyOpened)

                        }
                        
                        SectionButton(title: "Contact us") {
                            if MailView.canSendMail() {
                                self.viewModel.isShowingMailView = true
                            } else {
                                openURL(AppConfig.contactUsURL)
                            }
                            AnalyticsManager.shared.logEvent(eventType: .contactUsOpened)
                        }
                    }
                    
                    
                    
                    
                    
                    Section(header: Text("Ivan's apps")) {
                        AppLinks(url: AppConfig.triviaURL, imageName: "MusicTrivia", title: "Music Trivia")
                        AppLinks(url: AppConfig.aiBirthdayURL, imageName: "AIBirthday", title: "AI Birthday Reminder")
                        AppLinks(url: AppConfig.dailyUpURL, imageName: "DailyUp", title: "Daily Up")
                    }
                    
                    Section(header: Text("Legal")) {
                        SectionButton(title: "Terms of Use") {
                            openURL(AppConfig.termsOfUseURL)
                        }
                        
                        Button("Privacy Policy") {
                            showPrivacyPolicy = true
                        }
                    }
                }
                
            }
            
            Spacer()
            
            CreatorWords()
            
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showPromoCodeMenu) {
            PromoCodeView()
        }
        .sheet(isPresented: $showWishKit) {
            WishKitList()
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("Are you sure you want to do nothing?"),
                message: Text("There is no undo"),
                primaryButton: .destructive(
                    Text("Do nothing"),
                    action: {}
                ),
                secondaryButton: .default(
                    Text("Later")
                        .foregroundStyle(.blue),
                    action: {
                        viewModel.showingAlert = false
                    }
                )
            )
        }
        .sheet(isPresented: $viewModel.isShowingMailView) {
            MailView(isShowing: self.$viewModel.isShowingMailView, result: self.$viewModel.result)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView(subType: AppConfig.rcOfferingIds.first ?? "default").onDisappear {
                // 1 second delay for request to revenue cat - not propose discount to user that already purchased normal version
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if !MonetizationConfig.isPremiumAccount {
                        NSLog("no premium and paywall dismissed - show discount")
                        AnalyticsManager.shared.logEvent(eventType: .discountProProposed)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCategories) {
            ExpenseCategorySettingsView()
        }
        .onAppear {
            AnalyticsManager.shared.logEvent(eventType: .settingsScreen)

        }
        .navigationTitle(Text("Settings"))
    }
}

#Preview {
    SettingsScreen()
}

struct SectionButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(Color(.label))
    }
}
