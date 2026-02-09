import SwiftUI

/// Progress and Rewards screen displaying user's achievements
///
/// Purpose:
/// - Shows total completed lessons across all tracks
/// - Displays earned badges in a calm, non-competitive way
/// - Shows completed levels summary
/// - Reinforces confidence and progress
///
/// Architecture:
/// - Observes ProgressViewModel for progress statistics
/// - Observes LevelViewModel for level completion data
/// - No mutations, read-only display
///
/// Empty State Handling:
/// - Shows encouraging message when no progress exists
/// - Shows placeholder when no badges earned yet
/// - Never displays errors or blame
///
/// Accessibility:
/// - All text respects Dynamic Type
/// - Meaningful labels for badges and statistics
/// - Proper semantic grouping
struct ProgressView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @EnvironmentObject private var levelViewModel: LevelViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.large) {
                // Progress Summary Card
                progressSummaryCard
                
                // Badges Section
                badgesSection
                
                // Encouragement Message
                BirdGuideView(message: encouragementMessage)
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle("Your Progress")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
    
    // MARK: - Subviews
    
    /// Main progress statistics card
    private var progressSummaryCard: some View {
        CardView {
            VStack(spacing: AppSpacing.medium) {
                // Icon
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppColors.primary)
                    .accessibilityHidden(true)
                
                // Total lessons completed
                VStack(spacing: AppSpacing.xsmall) {
                    Text("\(completedLessonsCount)")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(completedLessonsCount == 1 ? "Lesson Completed" : "Lessons Completed")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Divider()
                    .padding(.vertical, AppSpacing.small)
                
                // Total badges earned
                VStack(spacing: AppSpacing.xsmall) {
                    HStack(spacing: AppSpacing.small) {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppColors.accent)
                        Text("\(earnedBadgesCount)")
                            .font(AppFonts.subtitle)
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Text(earnedBadgesCount == 1 ? "Badge Earned" : "Badges Earned")
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Progress Summary: \(completedLessonsCount) lessons completed, \(earnedBadgesCount) badges earned")
    }
    
    /// Badges display section
    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            // Section header
            Text("Badges")
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if earnedBadgesCount == 0 {
                // Empty state for badges
                EmptyStateView(
                    icon: "star",
                    title: "No Badges Yet",
                    message: "Keep learning to earn your first badge!"
                )
                .padding(.vertical, AppSpacing.large)
            } else {
                // Badge grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.medium) {
                    // Note: Badge data would come from a BadgesData source
                    // For now, showing placeholder based on earned count
                    ForEach(0..<earnedBadgesCount, id: \.self) { index in
                        badgePlaceholder(number: index + 1)
                    }
                }
            }
        }
    }
    
    /// Placeholder badge card
    /// In a complete implementation, this would display actual Badge data
    private func badgePlaceholder(number: Int) -> some View {
        VStack(spacing: AppSpacing.small) {
            ZStack {
                Circle()
                .fill(AppColors.accent.opacity(0.2))
                .frame(width: 60, height: 60)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 30))
                    .foregroundColor(AppColors.accent)
            }
            
            Text("Badge \(number)")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(AppSpacing.medium)
        .frame(maxWidth: .infinity)
        .background(AppColors.surface)
        .cornerRadius(12)
        .shadow(color: AppColors.shadow, radius: 2, x: 0, y: 1)
        .accessibilityLabel("Badge \(number) earned")
    }
    
    // MARK: - Computed Properties
    
    /// Total completed lessons count
    private var completedLessonsCount: Int {
        appState.userProgress.completedLessonsCount
    }
    
    /// Total earned badges count
    private var earnedBadgesCount: Int {
        appState.userProgress.earnedBadgesCount
    }
    
    /// Encouraging message based on progress
    private var encouragementMessage: String {
        if completedLessonsCount == 0 {
            return "Your learning journey starts here! Take the first step and complete your first lesson."
        } else if completedLessonsCount < 3 {
            return "You're off to a great start! Keep building your skills one lesson at a time."
        } else if completedLessonsCount < 10 {
            return "You're making excellent progress! Your dedication is paying off."
        } else {
            return "Incredible work! You're well on your way to becoming a Swift developer. Keep it up!"
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ProgressView()
            .environmentObject(ProgressViewModel())
            .environmentObject(LevelViewModel(
                levels: SampleData.levels,
                userProgress: UserProgress.default
            ))
    }
}
