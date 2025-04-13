//
//  WishKitList.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 27.03.2025.


import SwiftUI
import WishKit

struct WishKitList: View {
    
    var body: some View {
        WishKit.FeedbackListView().withNavigation()
        }
    
    init() {
        WishKit.configure(with: AppConfig.wishKitApi)
    }

}

#Preview {
    WishKitList()
}
