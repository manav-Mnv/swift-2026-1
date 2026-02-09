import Foundation

struct UserProgress: Codable {
    var completedLessonIds: Set<UUID>
    var earnedBadgeIds: Set<UUID>
    var currentLevelNumber: Int
    var selectedLearningPath: LearningPath
    var hasCompletedOnboarding: Bool
    
    init(completedLessonIds: Set<UUID> = [], earnedBadgeIds: Set<UUID> = [], currentLevelNumber: Int = 0, selectedLearningPath: LearningPath = .swift, hasCompletedOnboarding: Bool = false) {
        self.completedLessonIds = completedLessonIds
        self.earnedBadgeIds = earnedBadgeIds
        self.currentLevelNumber = max(0, currentLevelNumber) // Ensure non-negative
        self.selectedLearningPath = selectedLearningPath
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
    
    /// Safe, idempotent method to earn badge
    /// Can be called multiple times without side effects
    mutating func safeEarnBadge(_ badgeId: UUID) {
        earnedBadgeIds.insert(badgeId)
    }
    
    /// Reset all progress to initial state
    mutating func reset() {
        completedLessonIds.removeAll()
        earnedBadgeIds.removeAll()
        currentLevelNumber = 0
        hasCompletedOnboarding = false
        // Keep selectedLearningPath as-is
    }
    
    /// Get total completed lessons count
    var completedLessonsCount: Int {
        return completedLessonIds.count
    }
    
    /// Get total earned badges count
    var earnedBadgesCount: Int {
        return earnedBadgeIds.count
    }
}

enum LearningPath: String, Codable {
    case swift
    case swiftUI
}
