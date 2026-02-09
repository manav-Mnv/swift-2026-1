import Foundation

final class DefaultBadgeUnlockingService: BadgeUnlockingService {
    
    func unlockedBadges(
        badges: [Badge],
        progress: UserProgress
    ) -> [Badge] {
        
        badges.filter { badge in
            guard let rule = badge.machineRule else {
                // Badges without machine rules never unlock automatically
                return false
            }
            
            return shouldUnlock(rule: rule, progress: progress)
        }
    }
    
    // MARK: - Private Helper
    
    private func shouldUnlock(rule: BadgeRule, progress: UserProgress) -> Bool {
        switch rule {
        case .completeLevel(let levelNumber):
            return progress.completedLevelNumbers.contains(levelNumber)
            
        case .completeLessons(let count):
            return progress.completedLessonIds.count >= count
            
        case .completeTrack(let track):
            // For now, we can consider a track complete if the user selected it
            // In a real app, you'd check if all levels in that track are complete
            return progress.selectedLearningTrack == track
            
        case .firstLesson:
            return progress.completedLessonIds.count >= 1
            
        case .streakDays(let days):
            // Streak tracking not implemented yet, so always false
            // TODO: Implement streak tracking in UserProgress
            return false
        }
    }
}
