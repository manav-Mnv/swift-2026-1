import SwiftUI

struct BadgeView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.medium) {
                ForEach(BadgesData.allBadges) { badge in
                    let isEarned = appState.userProgress.earnedBadgeIds.contains(badge.id)
                    
                    CardView {
                        VStack(spacing: AppSpacing.small) {
                            Image(systemName: badge.iconName)
                                .font(.system(size: 50))
                                .foregroundColor(isEarned ? AppColors.primary : AppColors.disabled)
                            
                            Text(badge.title)
                                .font(AppFonts.subtitle)
                                .foregroundColor(isEarned ? AppColors.primary : AppColors.disabled)
                            
                            Text(badge.description)
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .opacity(isEarned ? 1.0 : 0.5)
                    }
                }
            }
            .padding(AppSpacing.large)
        }
        .navigationTitle("Badges")
    }
}
