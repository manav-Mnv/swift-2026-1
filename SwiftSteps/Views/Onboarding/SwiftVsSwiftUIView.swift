import SwiftUI

struct SwiftVsSwiftUIView: View {
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Text("Swift vs SwiftUI")
                .font(AppFonts.title)
                .foregroundColor(AppColors.primary)
            
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                CardView {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Swift")
                            .font(AppFonts.subtitle)
                            .foregroundColor(AppColors.primary)
                        
                        Text("The programming language - learn variables, functions, and logic")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                CardView {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("SwiftUI")
                            .font(AppFonts.subtitle)
                            .foregroundColor(AppColors.primary)
                        
                        Text("The UI framework - build beautiful interfaces")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            
            PrimaryButton(title: "Continue") {
                // Navigate to path selection
            }
        }
        .padding(AppSpacing.large)
    }
}
