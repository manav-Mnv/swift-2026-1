import SwiftUI

struct LevelCompletionView: View {
    let level: Level
    let earnedBadge: Badge?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Spacer()
            
            // Checkmark icon
            ZStack {
                Circle()
                    .fill(AppColors.success.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(AppColors.success)
            }
            
            // Completion message
            VStack(spacing: AppSpacing.small) {
                Text("Level Completed")
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(level.title)
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            // Badge (if earned)
            if let badge = earnedBadge {
                VStack(spacing: AppSpacing.small) {
                    Image(systemName: badge.iconName)
                        .font(.system(size: 48))
                        .foregroundColor(AppColors.accent)
                    
                    Text("Badge Earned!")
                        .font(AppFonts.subtitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(badge.title)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(AppSpacing.large)
                .background(AppColors.surface)
                .cornerRadius(16)
            }
            
            Spacer()
            
            // Continue button
            PrimaryButton(title: "Continue") {
                dismiss()
            }
            .padding(.horizontal, AppSpacing.medium)
        }
        .padding(AppSpacing.large)
        .background(AppColors.background)
        .navigationBarBackButtonHidden(true)
    }
}
