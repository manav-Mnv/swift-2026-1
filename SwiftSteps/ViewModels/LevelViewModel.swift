import Foundation
import SwiftUI

enum LevelState {
    case locked
    case unlocked
    case completed
}

class LevelViewModel: ObservableObject {
    @Published var availableLevels: [Level] = []
    @Published var currentLevel: Level?
    @Published var loadError: String?
    
    func loadLevelsForPath(_ path: LearningPath) {
        // Clear any previous error
        loadError = nil
        
        switch path {
        case .swift:
            availableLevels = [
                SwiftLevel0Data.level,
                SwiftLevel1Data.level,
                SwiftLevel2Data.level
            ]
        case .swiftUI:
            availableLevels = [
                SwiftUILevel0Data.level
            ]
        }
        
        // Validate loaded levels
        let invalidLevels = availableLevels.filter { !$0.isValid }
        if !invalidLevels.isEmpty {
            loadError = "Some levels couldn't be loaded correctly"
        }
    }
    
    func selectLevel(_ level: Level) {
        // Validate level before selection
        guard level.isValid else {
            loadError = "This level is not available"
            return
        }
        currentLevel = level
    }
    
    func isLevelUnlocked(_ levelNumber: Int, progress: ProgressViewModel) -> Bool {
        // Defensive: Validate level number
        guard levelNumber >= 0 else {
            return false
        }
        
        // Level 0 is always unlocked
        if levelNumber == 0 {
            return true
        }
        
        // Defensive: Check if levels exist
        guard !availableLevels.isEmpty else {
            return false
        }
        
        // Check if previous level exists and is completed
        if let previousLevel = availableLevels.first(where: { $0.levelNumber == levelNumber - 1 }) {
            // Defensive: Validate level has lessons
            guard previousLevel.hasLessons else {
                return false
            }
            return isLevelCompleted(previousLevel, progress: progress)
        }
        
        return false
    }
    
    func isLevelCompleted(_ level: Level, progress: ProgressViewModel) -> Bool {
        // Defensive: Check level has lessons
        guard level.hasLessons else {
            return false
        }
        
        // Check if all lessons in this level are completed
        for lesson in level.lessons {
            if !progress.isLessonCompleted(lesson.id) {
                return false
            }
        }
        return true
    }
    
    func getLevelState(_ level: Level, progress: ProgressViewModel) -> LevelState {
        if isLevelCompleted(level, progress: progress) {
            return .completed
        } else if isLevelUnlocked(level.levelNumber, progress: progress) {
            return .unlocked
        } else {
            return .locked
        }
    }
    
    // MARK: - Safety Helpers
    
    /// Check if any levels are currently loaded
    var hasLevels: Bool {
        return !availableLevels.isEmpty
    }
    
    /// Get count of available levels
    var levelCount: Int {
        return availableLevels.count
    }
}

