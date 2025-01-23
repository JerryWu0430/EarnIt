import SwiftUI

struct OnboardingFlow: View {
    @State private var currentStep = 1
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
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
                // Mark onboarding as complete
                viewModel.showOnboarding = false
            }
        }
    }
}

#Preview {
    OnboardingFlow()
        .environmentObject(AuthenticationViewModel())
} 