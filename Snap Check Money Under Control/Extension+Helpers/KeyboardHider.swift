//
//  KeyboardHider.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 18.11.2024.
//

import Foundation
import SwiftUI


class KeyboardHider {
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
