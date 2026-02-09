import SwiftUI

struct LevelListView: View {
    @EnvironmentObject var levelViewModel: LevelViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.medium) {
                    ForEach(levelViewModel.availableLevels) { level in
                        NavigationLink(destination: LessonView()) { // Note: LessonView needs verification
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
                                    
                                    Image(systemName: levelViewModel.isLevelUnlocked(level) ? "lock.open" : "lock")
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                        }
                        .disabled(!levelViewModel.isLevelUnlocked(level))
                    }
                }
                .padding(AppSpacing.large)
            }
            .navigationTitle("Levels")
        }
    }
}
