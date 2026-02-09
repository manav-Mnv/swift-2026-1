import SwiftUI

struct CodeEditorView: View {
    @Binding var code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Your Code")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.primary)
                .padding(.horizontal, AppSpacing.medium)
                .padding(.top, AppSpacing.small)
            
            TextEditor(text: $code)
                .font(AppFonts.code)
                .padding(AppSpacing.small)
                .background(AppColors.codeBackground)
                .cornerRadius(8)
                .padding(.horizontal, AppSpacing.medium)
        }
        .background(AppColors.surfaceSecondary)
    }
}
