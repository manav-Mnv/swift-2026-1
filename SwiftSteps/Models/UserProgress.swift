import Foundation

struct UserProgress: Codable {
    var completedLessonIds: Set<UUID>
    var completedLevelNumbers: Set<Int>
    var earnedBadgeIds: Set<UUID>
    
    var currentLevelNumber: Int
    var selectedLearningTrack: LearningTrack
    var hasCompletedOnboarding: Bool
    
    init(
        completedLessonIds: Set<UUID> = [],
        completedLevelNumbers: Set<Int> = [],
        earnedBadgeIds: Set<UUID> = [],
        currentLevelNumber: Int = 0,
        selectedLearningTrack: LearningTrack = .swift,
        hasCompletedOnboarding: Bool = false
    ) {
        self.completedLessonIds = completedLessonIds
        self.completedLevelNumbers = completedLevelNumbers
        self.earnedBadgeIds = earnedBadgeIds
        self.currentLevelNumber = max(0, currentLevelNumber) // Ensure non-negative
        self.selectedLearningTrack = selectedLearningTrack
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
    
    // MARK: - Safety & Validation
    
    /// Check if progress data is in a valid state
    var isValid: Bool {
        return currentLevelNumber >= 0
    }
    
    /// Safe, idempotent method to mark lesson as complete
    /// Can be called multiple times without side effects
    mutating func safeCompleteLesson(_ lessonId: UUID) {
        completedLessonIds.insert(lessonId)
    }
    
    /// Safe, idempotent method to mark level as complete
    mutating func safeCompleteLevel(_ levelNumber: Int) {
        guard levelNumber >= 0 else { return }
        completedLevelNumbers.insert(levelNumber)
    }
    
    /// Safe, idempotent method to earn badge
    /// Can be called multiple times without side effects
    mutating func safeEarnBadge(_ badgeId: UUID) {
        earnedBadgeIds.insert(badgeId)
    }
    
    /// Reset all progress to initial state
    mutating func reset() {
        completedLessonIds.removeAll()
        completedLevelNumbers.removeAll()
        earnedBadgeIds.removeAll()
        currentLevelNumber = 0
        hasCompletedOnboarding = false
        // Keep selectedLearningTrack as-is
    }
    
    /// Get total completed lessons count
    var completedLessonsCount: Int {
        return completedLessonIds.count
    }
    
    /// Get total completed levels count
    var completedLevelsCount: Int {
        return completedLevelNumbers.count
    }
    
    /// Get total earned badges count
    var earnedBadgesCount: Int {
        return earnedBadgeIds.count
    }
}
