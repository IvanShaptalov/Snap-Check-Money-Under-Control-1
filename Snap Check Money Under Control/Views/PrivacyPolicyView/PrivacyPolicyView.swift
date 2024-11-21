//
//  PrivacyPolicyView.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 21.11.2024.
//


import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy for Snap Check Money Under Control")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("Effective Date: 20 November 2024")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Divider()
                
                Text("""
                This Privacy Policy describes how Snap Check Money Under Control (“we,” “our,” or “us”), an individual located in Ukraine, collects, uses, and shares information about you when you use our mobile application Snap Check Money Under Control (the “App”).
                """)
                    .font(.body)
                
                Text("Information We Collect")
                    .font(.headline)
                
                Text("""
                1. Information You Provide:
                We do not collect any user information.
                
                2. Information Collected for Analytics:
                We collect information for analytics purposes using tools such as Google Firebase Analytics. This may include:
                  • Device information
                  • User engagement data
                """)
                
                Text("Use of Information")
                    .font(.headline)
                
                Text("""
                We use the collected information for analytics to enhance user experience and improve our services. We do not send emails to users, display ads, sell products/services, or engage in remarketing services for marketing & advertising purposes.
                """)
                
                Text("User Contact")
                    .font(.headline)
                
                Text("Users can contact us via email at wellbeing.vantage@icloud.com.")
                
                Text("Do We Share Your Information?")
                    .font(.headline)
                
                Text("""
                No, we do not share your information with third parties. Information collected is solely used for analytics within the App.
                """)
                
                Text("Compliance with Privacy Laws")
                    .font(.headline)
                
                Text("""
                1. CCPA and CPRA:
                Users in California have certain rights under CCPA and CPRA, including the right to request information about the categories of personal information collected. To exercise these rights, please contact us.
                
                2. GDPR:
                Users in the European Union have rights under GDPR, including the right to access, correct, or delete personal data. To exercise these rights, please contact us.
                
                3. CalOPPA:
                CalOPPA requires the disclosure of how the App responds to “Do Not Track” signals. The App does not currently respond to such signals.
                """)
                
                Text("Information Storage")
                    .font(.headline)
                
                Text("We do not store personal information but transfer data to third-party analytics services.")
                
                Text("Changes to this Privacy Policy")
                    .font(.headline)
                
                Text("We may update this Privacy Policy to reflect changes in our practices. Users are encouraged to review this policy periodically.")
                
                Text("Contact Us")
                    .font(.headline)
                
                Text("For any questions or concerns, please contact us at wellbeing.vantage@icloud.com.")
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}
