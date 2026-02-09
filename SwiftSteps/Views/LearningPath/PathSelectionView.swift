import SwiftUI

struct PathSelectionView: View {
    @EnvironmentObject var appState: AppStateViewModel
    @EnvironmentObject var levelViewModel: LevelViewModel
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Text("Choose Your Path")
                .font(AppFonts.title)
                .foregroundColor(AppColors.primary)
            
            VStack(spacing: AppSpacing.medium) {
                Button {
                    appState.selectLearningPath(.swift)
                    levelViewModel.loadLevelsForPath(.swift)
                } label: {
                    CardView {
                        VStack(spacing: AppSpacing.small) {
                            Image(systemName: "chevron.left.slash.chevron.right")
                                .font(.system(size: 50))
                                .foregroundColor(AppColors.primary)
                            
                            Text("Swift")
                                .font(AppFonts.subtitle)
                                .foregroundColor(AppColors.primary)
                            
                            Text("Learn the programming language")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Button {
                    appState.selectLearningPath(.swiftUI)
                    levelViewModel.loadLevelsForPath(.swiftUI)
                } label: {
                    CardView {
                        VStack(spacing: AppSpacing.small) {
                            Image(systemName: "square.stack.3d.up")
                                .font(.system(size: 50))
                                .foregroundColor(AppColors.primary)
                            
                            Text("SwiftUI")
                                .font(AppFonts.subtitle)
                                .foregroundColor(AppColors.primary)
                            
                            Text("Build beautiful interfaces")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(AppSpacing.large)
    }
}
