import SwiftUI
import RevenueCat

struct PaywallView: View {
    @State private var subscriptions: [SubscriptionObj] = []
    @State private var selectedPackage: Package?
    @State private var isProcessingPurchase = false
    @State private var showPurchaseSuccess = false
    @State private var errorMessage: ErrorWrapper? = nil
    @State var subType: String
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text(MonetizationConfig.isPremiumAccount ? "Already Pro 😎" : subType == "sale" ? "💰 Discounted Pro" : "Upgrade to Pro")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            // Premium Features
            PremiumFeaturesView()
                .padding(.bottom, 20)
            
            // Subscription Options
            if subscriptions.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ForEach(subscriptions, id: \.title) { subscription in
                    if subscription.package == selectedPackage {
                        SubscriptionRow(subscription: subscription)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPackage = subscription.package
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.cyan, lineWidth: 2)
                            )
                            .background(Color(uiColor: UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        
                    }
                    else {
                        SubscriptionRow(subscription: subscription)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    selectedPackage = subscription.package
                                }
                            }
                            .background(Color(uiColor: UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                }
            }
            
            // Purchase Button
            Button(action: makePurchase) {
                if isProcessingPurchase {
                    ProgressView()
                } else {
                    Text("Subscribe Now")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }
            }
            .padding(.top)
            
            // Restore Purchases
            Button("Restore Purchases", action: restorePurchases)
                .padding(.top, 5)
            
            // Privacy Policy Link
            Link("Privacy Policy", destination: AppConfig.privacyPolicyURL)
                .padding(.top, 5)
                .foregroundColor(.blue)
            
            
            Spacer()
        }
        .padding()
        .onAppear {
            withAnimation {
                loadSubscriptions()
                if subType == "default" {
                    AnalyticsManager.shared.logEvent(eventType: .proDirectOpen)
                }
                if subType == "sale" {
                    AnalyticsManager.shared.logEvent(eventType: .discountProProposed)
                }
            }
        }
        .alert(item: $errorMessage) { errorWrapper in
            Alert(title: Text("Info"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK")))
        }
        .onDisappear {
            withAnimation {
                if subType == "default" {
                    AnalyticsManager.shared.logEvent(eventType: .proPageClosed)
                }
                if subType == "sale" {
                    AnalyticsManager.shared.logEvent(eventType: .discountProClosed)
                }
            }
        }
    }
    
    // Load subscriptions from RevenueCatService
    private func loadSubscriptions() {
        if RevenueCatService.offerings.isEmpty {
            RevenueCatService.getOfferingById(ids: ["default", "sale"]) { result in
                switch result {
                case .success(let offerings):
                    var allSubscriptions: [SubscriptionObj] = []
                    if let subs = offerings[subType] {
                        allSubscriptions.append(contentsOf: subs)
                        
                    }
                    
                    self.subscriptions = allSubscriptions
                    self.selectedPackage = subscriptions.first?.package
                case .failure(let error):
                    print(error.localizedDescription)
                    errorMessage = ErrorWrapper(message:"Failed to load subscriptions")
                }
            }
        } else {
            self.subscriptions = RevenueCatService.offerings[subType] ?? []
            self.selectedPackage = subscriptions.first?.package
        }
    }
    
    // Make a purchase
    private func makePurchase() {
        withAnimation {
            guard let package = selectedPackage else { errorMessage = ErrorWrapper(message: "Select Plan Firstly")
                return}
            isProcessingPurchase = true
            if subType == "default" {
                AnalyticsManager.shared.logEvent(eventType: .proPurchase)
            }
            if subType == "sale" {
                AnalyticsManager.shared.logEvent(eventType: .discountProPurchase)
            }
            
            RevenueCatService.makePurchase(package: package) { status in
                isProcessingPurchase = false
                switch status {
                case .Success:
                    showPurchaseSuccess = true
                case .PurchaseCancelled:
                    print("Puchase was cancelled")
                    
                    AnalyticsManager.shared.logEvent(eventType: .proPurchaseFailed)
                case .PurchaseNotAllowedError:
                    errorMessage = ErrorWrapper(message:"Purchase not allowed on this device.")
                    AnalyticsManager.shared.logEvent(eventType: .proPurchaseFailed)
                    
                case .PurchaseInvalidError:
                    errorMessage = ErrorWrapper(message:"Invalid purchase. Please try again.")
                    AnalyticsManager.shared.logEvent(eventType: .proPurchaseFailed)
                    
                default:
                    print("defaull : all ok")
                }
            }
        }
    }
    
    // Restore purchases
    private func restorePurchases() {
        withAnimation {
            RevenueCatService.restorePurchase { success in
                if success {
                    showPurchaseSuccess = true
                    errorMessage = ErrorWrapper(message: "Purchases restored ✅")
                    AnalyticsManager.shared.logEvent(eventType: .proPurchaseRestored)
                    
                } else {
                    AnalyticsManager.shared.logEvent(eventType: .proPurchaseRestoreFailed)
                    errorMessage = ErrorWrapper(message:"Failed to restore purchases.")
                }
            }
        }
    }
}


struct PremiumFeaturesView: View {
    var body: some View {
        VStack(spacing: 20) {
            FeatureItemView(iconName: "arrow.down.doc", title: "Unlimited Checks Export", description: "Export checks to Excel, text, Numbers, and PDF.")
            
            FeatureItemView(iconName: "nosign", title: "No Ads", description: "Enjoy a seamless experience without interruptions or ads.")
            
            Spacer()
        }
        .padding()
    }
}

struct FeatureItemView: View {
    let iconName: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.blue)
            
            Spacer()
                .frame(width: 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
            }
            
            Spacer()
            
        }
    }
}


struct SubscriptionRow: View {
    let subscription: SubscriptionObj
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(subscription.title)
                    .font(.headline)
                
                Text(subscription.priceDuration)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if subscription.isFreeTrial {
                    Text("Free Trial Available")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Text(String(format: "%.2f$", NSDecimalNumber(decimal: subscription.totalPrice).doubleValue))
                .font(.headline)
        }
        .frame(height: UIScreen.main.bounds.height * 0.08)
        .padding()
    }
}
