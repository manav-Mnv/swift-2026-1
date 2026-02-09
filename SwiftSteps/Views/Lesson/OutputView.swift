import SwiftUI

struct OutputView: View {
    let output: String
    let isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack {
                Text("Output")
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.primary)
                
                Spacer()
                
                if !output.isEmpty {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? AppColors.success : AppColors.error)
                }
            }
            .padding(.horizontal, AppSpacing.medium)
            .padding(.top, AppSpacing.small)
            
            ScrollView {
                Text(output.isEmpty ? "Run your code to see the output" : output)
                    .font(AppFonts.code)
                    .foregroundColor(output.isEmpty ? AppColors.textSecondary : AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppSpacing.small)
            }
            .background(AppColors.codeBackground)
            .cornerRadius(8)
            .padding(.horizontal, AppSpacing.medium)
            .padding(.bottom, AppSpacing.small)
        }
        .background(AppColors.surfaceSecondary)
    }
}
