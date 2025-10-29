import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text(message)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.8))
                    )
                    .shadow(radius: 4)
            }
            .padding(.bottom, 20)
        }
        .opacity(isShowing ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}
