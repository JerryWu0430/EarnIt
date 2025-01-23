import SwiftUI
import FirebaseAuth

struct PendingVerificationView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var timer: Timer?
    
    // Get access to root presentation mode
    @Environment(\.presentationMode) var presentationMode
    @Binding var rootIsPresented: Bool

    var body: some View {
        VStack {
            Text("Please verify your email")
                .font(.title)
                .padding()
            Text("A verification email has been sent to your email address. Please verify to continue.")
                .multilineTextAlignment(.center)
                .padding()
            Button("Resend Email") {
                Task {
                    try? await Auth.auth().currentUser?.sendEmailVerification()
                }
            }
            .padding()
        }
        .onAppear {
            startEmailVerificationCheck()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startEmailVerificationCheck() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task {
                await viewModel.checkEmailVerification()
                if await viewModel.isEmailVerified {
                    // Dismiss all the way back to root
                    rootIsPresented = false
                }
            }
        }
    }
}

struct PendingVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        PendingVerificationView(rootIsPresented: .constant(true))
            .environmentObject(AuthenticationViewModel())
    }
} 