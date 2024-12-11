import SwiftUI

struct PromoCodeView: View {
    @State private var promoCode: String = AppConfig.currentPromocode
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text(AppConfig.promocodes.contains(promoCode.lowercased()) ? "Promocode activated 🤩" : "Get Pro via Promocode 😎")
                .font(.title)
                .padding(.bottom, 10)
            
            if !AppConfig.expiredPromocodes.isEmpty {
                Text("Expired Promocodes 🕰️")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                List(AppConfig.expiredPromocodes, id: \.self) { code in
                    Text(code.uppercased())
                        .foregroundColor(.gray)
                        .italic()
                }
                .frame(height: 150) // Ограничение высоты списка
            }
            
            Spacer()


            TextField("Enter promo code", text: $promoCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.allCharacters)
                .onChange(of: promoCode) { _, newValue in
                    promoCode = newValue.uppercased()
                }
            
            Button(action: {
                if AppConfig.promocodes.contains(promoCode.lowercased()) {
                    alertTitle = "🎉 Success!"
                    alertMessage = "Promo code applied successfully. You are now Pro!"
                    AppConfig.currentPromocode = promoCode
                    if MonetizationConfig.isPremiumAccount {
                        AnalyticsManager.shared.logEvent(eventType: .pro_via_promocode)
                    }
                } else {
                    alertTitle = "❌ Invalid Code"
                    AppConfig.currentPromocode = ""
                    alertMessage = "The promo code you entered is not valid. Please try again."
                }
                showAlert = true
            }) {
                Text("Get Pro Version")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            Spacer().frame(height: 10)
        }
        .padding()
    }
}

#Preview {
    PromoCodeView()
}
