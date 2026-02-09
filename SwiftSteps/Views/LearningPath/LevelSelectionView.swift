import SwiftUI

struct LevelSelectionView: View {
    let learningPath: LearningPath
    
    @EnvironmentObject var levelViewModel: LevelViewModel
    @EnvironmentObject var progressViewModel: ProgressViewModel
    
    @State private var navigateToLessonList = false
    @State private var selectedLevel: Level?
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.medium) {
                // Header
                VStack(spacing: AppSpacing.small) {
                    Text(learningPath == .swift ? "Swift Levels" : "SwiftUI Levels")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Progress through levels to master the fundamentals")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppSpacing.medium)
                
                // Level cards
                if levelViewModel.availableLevels.isEmpty {
                    EmptyStateView(
                        icon: "book.closed.fill",
                        title: "No Levels Available",
                        message: "There are no levels in this track yet."
                    )
                    .padding(.top, AppSpacing.xlarge)
                } else {
                    ForEach(levelViewModel.availableLevels) { level in
                        let state = levelViewModel.getLevelState(level, progress: progressViewModel)
                        let completedCount = progressViewModel.completedLessonsInLevel(level)
                        let itemState = convertLevelStateToItemState(state)
                        
                        LevelCard(
                            level: level,
                            state: itemState,
                            completedLessons: completedCount,
                            isDisabled: state == .locked
                        ) {
                            if state != .locked {
                                selectedLevel = level
                                levelViewModel.selectLevel(level)
                                navigateToLessonList = true
                            }
                        }
                    }
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(learningPath == .swift ? "Swift" : "SwiftUI")
        .navigationDestination(isPresented: $navigateToLessonList) {
            if let level = selectedLevel {
                LessonListView(level: level)
                    .environmentObject(levelViewModel)
                    .environmentObject(progressViewModel)
            }
        }
        .onAppear {
            levelViewModel.loadLevelsForPath(learningPath)
        }
    }
    
    private func convertLevelStateToItemState(_ levelState: LevelState) -> ItemState {
        switch levelState {
        case .locked:
            return .locked
        case .unlocked:
            return .unlocked
        case .completed:
            return .completed
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(AppColors.disabled)
            
            Text(title)
                .font(AppFonts.subtitle)
                .foregroundColor(AppColors.textPrimary)
            
            Text(message)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.large)
    }
}
