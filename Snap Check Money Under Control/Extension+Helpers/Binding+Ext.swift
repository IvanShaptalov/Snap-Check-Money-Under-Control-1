import SwiftUI

extension Binding where Value == ErrorWrapper? {
    static func combine(_ bindings: Binding<ErrorWrapper?>...) -> Binding<ErrorWrapper?> {
        return Binding<ErrorWrapper?>(
            get: {
                bindings.compactMap { $0.wrappedValue }.first
            },
            set: { newValue in
                for binding in bindings {
                    binding.wrappedValue = newValue
                }
            }
        )
    }
}
