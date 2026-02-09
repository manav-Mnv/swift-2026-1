import SwiftUI

struct LevelCard: View {
    let level: Level
    let state: ItemState
    let completedLessons: Int
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack {
                    Text("Level \(level.levelNumber)")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    StateIndicator(state: state)
                }
                
                Text(level.title)
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Text(level.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                if state != .locked {
                    ProgressBar(completed: completedLessons, total: level.lessons.count)
                }
            }
            .padding(AppSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(state == .locked ? AppColors.surface.opacity(0.5) : AppColors.surface)
            .cornerRadius(12)
            .shadow(color: AppColors.shadow, radius: 4, x: 0, y: 2)
            .opacity(isDisabled ? 0.6 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
        .accessibilityLabel("Level \(level.levelNumber): \(level.title)")
        .accessibilityHint(state == .locked ? "This level is locked" : "Tap to view lessons")
        .accessibilityAddTraits(.isButton)
        .accessibilityRemoveTraits(isDisabled ? .isEnabled : [])
    }
}
