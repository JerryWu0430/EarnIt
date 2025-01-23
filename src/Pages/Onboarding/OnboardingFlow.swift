import SwiftUI

struct OnboardingFlow: View {
    @State private var currentStep = 1
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                switch currentStep {
                case 1:
                    Onboarding_1(currentStep: $currentStep)
                case 2:
                    Onboarding_3(currentStep: $currentStep)
                case 3:
                    Onboarding_4(currentStep: $currentStep)
                case 4:
                    Onboarding_5(currentStep: $currentStep)
                case 5:
                    Onboarding_6(currentStep: $currentStep)
                default:
                    EmptyView()
                }
            }
            .onChange(of: currentStep) { newValue in
                if newValue > 5 {
                    dismiss() // Return to main app flow
                }
            }
        }
    }
}

#Preview {
    OnboardingFlow()
} 