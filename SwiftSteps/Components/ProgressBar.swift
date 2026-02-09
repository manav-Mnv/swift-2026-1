import SwiftUI

struct ProgressBar: View {
    let completed: Int
    let total: Int
    
    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("\(completed) of \(total) lessons completed")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textSecondary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.disabled.opacity(0.2))
                        .frame(height: 8)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.primary)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
        .accessibilityLabel("\(completed) of \(total) lessons completed")
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}
