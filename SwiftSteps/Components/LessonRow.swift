import SwiftUI

struct LessonRow: View {
    let lessonNumber: Int
    let lesson: Lesson
    let state: ItemState
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.medium) {
                // Lesson number badge
                ZStack {
                    Circle()
                        .fill(state == .locked ? AppColors.disabled.opacity(0.3) : AppColors.primary.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Text("\(lessonNumber)")
                        .font(AppFonts.body)
                        .fontWeight(.semibold)
                        .foregroundColor(state == .locked ? AppColors.textSecondary : AppColors.primary)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                    Text(lesson.title)
                        .font(AppFonts.body)
                        .foregroundColor(state == .locked ? AppColors.textSecondary : AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(lesson.description)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Spacer()
                
                StateIndicator(state: state)
            }
            .padding(AppSpacing.medium)
            .background(AppColors.surface)
            .cornerRadius(12)
            .shadow(color: AppColors.shadow, radius: 2, x: 0, y: 1)
            .opacity(isDisabled ? 0.6 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
        .accessibilityLabel("Lesson \(lessonNumber): \(lesson.title)")
        .accessibilityHint(state == .locked ? "This lesson is locked" : "Tap to start lesson")
        .accessibilityAddTraits(isDisabled ? [.isButton, .isNotEnabled] : .isButton)
    }
}
