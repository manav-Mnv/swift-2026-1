import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            // Welcome illustration or animation
            
            Text("Welcome to SwiftSteps")
                .font(AppFonts.title)
                .foregroundColor(AppColors.primary)
            
            Text("Learn Swift and SwiftUI at your own pace")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            PrimaryButton(title: "Get Started") {
                // Navigate to next onboarding screen
            }
        }
        .padding(AppSpacing.large)
    }
}
