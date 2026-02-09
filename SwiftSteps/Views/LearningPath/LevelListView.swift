import SwiftUI

struct LevelListView: View {
    @EnvironmentObject var levelViewModel: LevelViewModel
    @EnvironmentObject var progressViewModel: ProgressViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.medium) {
                    ForEach(levelViewModel.availableLevels) { level in
                        NavigationLink(destination: LessonView()) {
                            CardView {
                                HStack {
                                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                                        Text(level.title)
                                            .font(AppFonts.subtitle)
                                            .foregroundColor(AppColors.primary)
                                        
                                        Text(level.description)
                                            .font(AppFonts.body)
                                            .foregroundColor(AppColors.textSecondary)
                                        
                                        Text("\(level.lessons.count) lessons")
                                            .font(AppFonts.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: levelViewModel.isLevelUnlocked(level.levelNumber) ? "lock.open" : "lock")
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                        }
                        .disabled(!levelViewModel.isLevelUnlocked(level.levelNumber))
                    }
                }
                .padding(AppSpacing.large)
            }
            .navigationTitle("Levels")
        }
    }
}
