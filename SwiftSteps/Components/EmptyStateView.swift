import SwiftUI

/// Reusable empty state component for a calm, consistent UX
/// Used across all list views when content is not available
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String = "tray",
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
                .accessibilityHidden(true)
            
            // Title
            Text(title)
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            
            // Message
            Text(message)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.large)
            
            // Optional action button
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.top, AppSpacing.small)
            }
        }
        .padding(AppSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
}

// MARK: - UserMessage Convenience Initializer

extension EmptyStateView {
    /// Create an EmptyStateView from a UserMessage
    init(
        userMessage: UserMessage,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.init(
            icon: userMessage.icon,
            title: userMessage.message.components(separatedBy: ".").first ?? userMessage.message,
            message: userMessage.message,
            actionTitle: actionTitle,
            action: action
        )
    }
}

// MARK: - Preview

#Preview {
    EmptyStateView(
        icon: "book.closed",
        title: "No Lessons Available",
        message: "Check back soon for new lessons!",
        actionTitle: "Go Home",
        action: {}
    )
}
