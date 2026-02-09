import SwiftUI

/// The main home screen shown after onboarding completion.
/// 
/// Purpose:
/// - Primary entry point for returning users
/// - Shows current learning progress at a glance
/// - Provides one clear action: "Continue Learning"
/// - Reduces cognitive load with minimal UI elements
///
/// Architecture:
/// - Uses NavigationStack as the root container for the app's navigation flow
/// - Observes ProgressViewModel for progress statistics
/// - Observes LevelViewModel to ensure levels are loaded
/// - Navigation state managed via @State boolean (showLearningPath)
/// - State-driven navigation using .navigationDestination modifier
///
/// Empty State Handling:
/// - Shows "0 lessons completed" if no progress exists
/// - Button remains enabled to allow user to start learning
///
/// Accessibility:
/// - All text respects Dynamic Type via semantic fonts
/// - Meaningful accessibility labels on all interactive elements
/// - Sufficient contrast via design system colors
struct HomeView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var appState: AppStateViewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.large) {
                // MARK: Welcome Header
                welcomeHeader
                
                // MARK: Progress Summary Card
                progressSummaryCard
                
                // MARK: Bird Guide Encouragement
                BirdGuideView(message: motivationalMessage)
                
                // MARK: Primary Action
                PrimaryButton(title: "Continue Learning") {
                    appState.goToLevels()
                }
                .padding(.top, AppSpacing.medium)
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle("SwiftSteps")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
    }
    
    // MARK: - Subviews
    
    /// Welcome header with greeting
    /// 
    /// Why a VStack:
    /// - Vertically stacks the greeting and subtitle
    /// - Leading alignment ensures left-aligned text (supports LTR reading)
    private var welcomeHeader: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
            Text("Welcome back!")
                .font(AppFonts.title)
                .foregroundColor(AppColors.textPrimary)
                .accessibilityAddTraits(.isHeader)
            
            Text("Ready to continue your journey?")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Progress summary card showing completed lessons
    ///
    /// Why CardView:
    /// - Provides visual separation from background
    /// - Consistent with design system
    /// - Creates a clear visual hierarchy
    ///
    /// Why HStack:
    /// - Horizontally arranges icon and text
    /// - Creates a compact, scannable layout
    private var progressSummaryCard: some View {
        CardView {
            HStack(spacing: AppSpacing.medium) {
                // Progress icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.accent)
                    .accessibilityHidden(true) // Decorative
                
                VStack(alignment: .leading, spacing: AppSpacing.xsmall) {
                    Text("Your Progress")
                        .font(AppFonts.subtitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("\(completedLessonsCount) lessons completed")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Your Progress: \(completedLessonsCount) lessons completed")
    }
    
    // MARK: - Computed Properties
    
    /// Number of completed lessons from ProgressViewModel
    /// 
    /// Empty State Handling:
    /// - Returns 0 if completedLessonIds is empty
    /// - No crashes or force-unwraps
    private var completedLessonsCount: Int {
        appState.levelViewModel.userProgress.completedLessonIds.count
    }
    
    /// Motivational message based on progress
    ///
    /// Why dynamic messages:
    /// - Provides encouragement tailored to progress
    /// - Creates a more personal, engaging experience
    /// - Reinforces calm, confidence-building tone
    private var motivationalMessage: String {
        if completedLessonsCount == 0 {
            return "Let's start your Swift learning adventure! Take your first step today."
        } else if completedLessonsCount < 5 {
            return "Great start! You're building a strong foundation. Keep going!"
        } else {
            return "Amazing progress! You're becoming a Swift developer. Keep it up!"
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
        .environmentObject(AppStateViewModel())
}
