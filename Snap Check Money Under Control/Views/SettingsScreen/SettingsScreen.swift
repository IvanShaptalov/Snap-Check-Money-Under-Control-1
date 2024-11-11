import SwiftUI
import MessageUI


struct SettingsScreen: View {
    
    @StateObject var viewModel = SettingsScreenViewModel()
    @Environment(\.openURL) private var openURL
    @State private var showingPaywall = false // State variable to control the paywall
    @State private var proposeDiscountedPaywall = false
    @State private var discountedPaywall = false
    @State private var showingCategories = false
    @State private var selectedCurrency: Currency = AppConfig.mainCurrency {
        didSet {
            AnalyticsManager.shared.logEvent(eventType: .currencyChanged)
            AppConfig.updateMainCurrency(to: selectedCurrency)
            print("Selected currency changed to: \(selectedCurrency.rawValue)") // Debugging print
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
                    }
                    
                    Section(header: Text("App Configuration")) {
                        Picker("Currency", selection: $selectedCurrency) {
                            ForEach(Currency.allCases, id: \.self) { currency in
                                Text(currency.description)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: selectedCurrency) { _,newValue in
                            print("Picker selection changed to: \(newValue.description)") // Debugging print
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
                        
                        SectionButton(title: "Privacy Policy") {
                            openURL(AppConfig.privacyPolicyURL)
                        }
                    }
                }
                
            }
            
            Spacer()
            
            CreatorWords()
            
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
            PaywallView(subType: "default").onDisappear {
                if !MonetizationConfig.isPremiumAccount {
                    print("no premium and paywall dismissed - show discount")
                    proposeDiscountedPaywall = true
                    AnalyticsManager.shared.logEvent(eventType: .discountProProposed)
                }
            }
        }
        .sheet(isPresented: $discountedPaywall) {

            return PaywallView(subType: "sale")
        }
        .confirmationDialog("Discount for You!", isPresented: $proposeDiscountedPaywall, actions: {
            Button("Apply Discount") {
                // Применить скидку
                discountedPaywall = true // После применения скидки показываем предложение
                print("Discount applied!")
                AnalyticsManager.shared.logEvent(eventType: .discountProOpened)

            }
            Button("Not Now", role: .cancel) {
                // Отказаться от скидки
                discountedPaywall = false // Скрыть предложение о скидке
                print("Discount not applied")
                AnalyticsManager.shared.logEvent(eventType: .discountProNotNow)

            }
        })
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
