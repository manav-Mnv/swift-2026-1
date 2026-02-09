import Foundation
import SwiftUI

class ProgressViewModel: ObservableObject {
    @Published var userProgress: UserProgress
    
    init() {
        // Load progress from StorageManager
        self.userProgress = UserProgress()
    }
    
    func completeLesson(_ lessonId: UUID) {
        // Use safe, idempotent method from UserProgress
        userProgress.safeCompleteLesson(lessonId)
        saveProgress()
        checkForNewBadges()
    }
    
    func earnBadge(_ badgeId: UUID) {
        // Use safe, idempotent method from UserProgress
        userProgress.safeEarnBadge(badgeId)
        saveProgress()
    }
    
    func isLessonCompleted(_ lessonId: UUID) -> Bool {
        return userProgress.completedLessonIds.contains(lessonId)
    }
    
    func completedLessonsInLevel(_ level: Level) -> Int {
        // Defensive: Check level has lessons
        guard level.hasLessons else {
            return 0
        }
        
        var count = 0
        for lesson in level.lessons {
            if isLessonCompleted(lesson.id) {
                count += 1
            }
        }
        return count
    }
    
    func checkLevelCompletion(_ level: Level) -> Bool {
        // Defensive: Check level has lessons
        guard level.hasLessons else {
            return false
        }
        
        // Returns true if all lessons in the level are completed
        for lesson in level.lessons {
            if !isLessonCompleted(lesson.id) {
                return false
            }
        }
        return true
    }
    
    private func saveProgress() {
        // Save to StorageManager
        // Defensive: Only save if progress is valid
        guard userProgress.isValid else {
            return
        }
    }
    
    private func checkForNewBadges() {
        // Check unlock conditions for badges
    }
    
    // MARK: - Safety Helpers
    
    /// Get total completed lessons count safely
    var totalCompletedLessons: Int {
        return userProgress.completedLessonsCount
    }
    
    /// Get total earned badges count safely
    var totalEarnedBadges: Int {
        return userProgress.earnedBadgesCount
    }
    
    /// Reset all progress (useful for testing or user request)
    func resetProgress() {
        userProgress.reset()
        saveProgress()
    }
}
