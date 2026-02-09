import SwiftUI

enum ItemState {
    case locked
    case unlocked
    case completed
}

struct StateIndicator: View {
    let state: ItemState
    
    var body: some View {
        HStack(spacing: AppSpacing.xsmall) {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(iconColor)
            
            Text(stateText)
                .font(AppFonts.caption)
                .foregroundColor(textColor)
        }
        .padding(.horizontal, AppSpacing.small)
        .padding(.vertical, AppSpacing.xsmall)
        .background(backgroundColor)
        .cornerRadius(8)
        .accessibilityLabel(accessibilityText)
    }
    
    private var iconName: String {
        switch state {
        case .locked:
            return "lock.fill"
        case .unlocked:
            return "circle"
        case .completed:
            return "checkmark.circle.fill"
        }
    }
    
    private var iconColor: Color {
        switch state {
        case .locked:
            return AppColors.disabled
        case .unlocked:
            return AppColors.primary
        case .completed:
            return AppColors.success
        }
    }
    
    private var textColor: Color {
        switch state {
        case .locked:
            return AppColors.textSecondary
        case .unlocked:
            return AppColors.textPrimary
        case .completed:
            return AppColors.success
        }
    }
    
    private var backgroundColor: Color {
        switch state {
        case .locked:
            return AppColors.disabled.opacity(0.1)
        case .unlocked:
            return AppColors.primary.opacity(0.1)
        case .completed:
            return AppColors.success.opacity(0.1)
        }
    }
    
    private var stateText: String {
        switch state {
        case .locked:
            return "Locked"
        case .unlocked:
            return "Available"
        case .completed:
            return "Completed"
        }
    }
    
    private var accessibilityText: String {
        switch state {
        case .locked:
            return "This item is locked"
        case .unlocked:
            return "This item is available"
        case .completed:
            return "This item is completed"
        }
    }
}
