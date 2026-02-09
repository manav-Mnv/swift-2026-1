import Foundation
import SwiftUI
import Combine

final class LevelViewModel: ObservableObject {

    // MARK: - Published State (UI-relevant only)
    @Published private(set) var levels: [Level]
    @Published var userProgress: UserProgress // Changed to public/internal set for binding

    // MARK: - Computed Properties
    var availableLevels: [Level] {
        return levels
    }
    
    var hasLevels: Bool {
        return !levels.isEmpty
    }

    // MARK: - Init
    init(levels: [Level], userProgress: UserProgress) {
        self.levels = levels.sorted { $0.levelNumber < $1.levelNumber }
        self.userProgress = userProgress
    }
    
    // MARK: - Sync
    func updateProgress(_ progress: UserProgress) {
        self.userProgress = progress
    }
    
    // MARK: - Track Loading
    func loadLevelsForTrack(_ track: LearningTrack) {
        // Filter levels by track if needed
        // For now, levels are already loaded
    }

    // MARK: - Level State Queries

    func isLevelUnlocked(_ level: Level) -> Bool {
        if level.levelNumber == 0 {
            return true
        }

        return userProgress.completedLevelNumbers.contains(level.levelNumber - 1)
    }

    func isLevelCompleted(_ level: Level) -> Bool {
        userProgress.completedLevelNumbers.contains(level.levelNumber)
    }

    // MARK: - Lesson State Queries

    func isLessonUnlocked(_ lesson: Lesson, in level: Level) -> Bool {
        guard isLevelUnlocked(level) else { return false }

        guard let index = level.lessons.firstIndex(where: { $0.id == lesson.id }) else {
            return false
        }

        if index == 0 {
            return true
        }

        let previousLesson = level.lessons[index - 1]
        return userProgress.completedLessonIds.contains(previousLesson.id)
    }

    // MARK: - Progress Updates

    func markLessonCompleted(_ lesson: Lesson, in level: Level) {
        // Mutating struct in published property triggers objectWillChange
        userProgress.completedLessonIds.insert(lesson.id)

        if isLevelNowCompleted(level) {
            userProgress.completedLevelNumbers.insert(level.levelNumber)
        }
    }
    
    // Generic complete lesson for when level context might be missing (e.g. from LessonDetailView)
    func completeLesson(_ lessonId: UUID) {
         userProgress.completedLessonIds.insert(lessonId)
         // Note: We can't easily check level completion here without the level object, 
         // but that's okay for now. The comprehensive check happens when marking by level.
    }

    // MARK: - Helpers
    
    func completedLessonsInLevel(_ level: Level) -> Int {
        let levelLessonIds = level.lessons.map { $0.id }
        return levelLessonIds.filter { userProgress.completedLessonIds.contains($0) }.count
    }

    private func isLevelNowCompleted(_ level: Level) -> Bool {
        let lessonIds = Set(level.lessons.map { $0.id })
        return lessonIds.isSubset(of: userProgress.completedLessonIds)
    }
}
