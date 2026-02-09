import SwiftUI

struct BirdGuideView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            // Bird mascot icon or illustration
            Image(systemName: "bird.fill")
                .font(.system(size: 40))
                .foregroundColor(AppColors.accent)
            
            VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                Text("Guide")
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Text(message)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.medium)
        .background(AppColors.surfaceSecondary)
        .cornerRadius(12)
    }
}
