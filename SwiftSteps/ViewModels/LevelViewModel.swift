import Foundation
import SwiftUI
import Combine

final class LevelViewModel: ObservableObject {

    // MARK: - Published State (UI-relevant only)
    @Published private(set) var levels: [Level]
    @Published private(set) var userProgress: UserProgress

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
    
    func isLevelCompleted(_ level: Level, progress: ProgressViewModel) -> Bool {
        progress.isLevelCompleted(level.levelNumber)
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
        userProgress.completedLessonIds.insert(lesson.id)

        if isLevelNowCompleted(level) {
            userProgress.completedLevelNumbers.insert(level.levelNumber)
        }
    }

    // MARK: - Private Helpers

    private func isLevelNowCompleted(_ level: Level) -> Bool {
        let lessonIds = Set(level.lessons.map { $0.id })
        return lessonIds.isSubset(of: userProgress.completedLessonIds)
    }
}
