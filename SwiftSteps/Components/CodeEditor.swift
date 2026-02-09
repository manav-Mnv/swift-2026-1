import SwiftUI

struct CodeEditor: View {
    @Binding var code: String
    let placeholder: String
    
    init(code: Binding<String>, placeholder: String = "// Write your code here") {
        self._code = code
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if code.isEmpty {
                Text(placeholder)
                    .font(AppFonts.code)
                    .foregroundColor(AppColors.textSecondary.opacity(0.5))
                    .padding(AppSpacing.medium)
            }
            
            TextEditor(text: $code)
                .font(AppFonts.code)
                .foregroundColor(AppColors.textPrimary)
                .padding(AppSpacing.small)
                .scrollContentBackground(.hidden)
                .background(AppColors.codeBackground)
        }
        .background(AppColors.codeBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppColors.disabled.opacity(0.3), lineWidth: 1)
        )
        .accessibilityLabel("Code editor")
        .accessibilityHint("Enter your Swift code here")
    }
}
