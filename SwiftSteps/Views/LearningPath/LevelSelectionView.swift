import SwiftUI

struct LevelSelectionView: View {
    @ObservedObject var viewModel: LevelViewModel
    
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.medium) {
                // Header
                VStack(spacing: AppSpacing.small) {
                    Text("Swift Levels")
                        .font(AppFonts.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Progress through levels to master the fundamentals")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppSpacing.medium)
                
                // Level cards
                if viewModel.availableLevels.isEmpty {
                    EmptyStateView(
                        icon: "book.closed.fill",
                        title: "No Levels Available",
                        message: "There are no levels in this track yet."
                    )
                    .padding(.top, AppSpacing.xlarge)
                } else {
                    ForEach(viewModel.availableLevels) { level in
                        let state = viewModel.getLevelState(level)
                        let completedCount = viewModel.completedLessonsInLevel(level)
                        let itemState = convertLevelStateToItemState(state)
                        
                        LevelCard(
                            level: level,
                            state: itemState,
                            completedLessons: completedCount,
                            isDisabled: state == .locked
                        ) {
                            if state != .locked {
                                appState.goToLessons(for: level)
                            }
                        }
                    }
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle("Swift")
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
