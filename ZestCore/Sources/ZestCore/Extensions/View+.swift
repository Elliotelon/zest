import SwiftUI

extension View {
    public func toast(message: Binding<String?>) -> some View {
            self.alert(
                "알림",
                isPresented: Binding(
                    get: { message.wrappedValue != nil },
                    set: { _ in message.wrappedValue = nil }
                )
            ) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(message.wrappedValue ?? "")
            }
        }
}
