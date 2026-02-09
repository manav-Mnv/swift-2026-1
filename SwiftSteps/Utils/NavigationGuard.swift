import Foundation

/// Centralized navigation validation to prevent invalid navigation states
/// Ensures users can only navigate to accessible content
struct NavigationGuard {
    
    // MARK: - Lesson Navigation Validation
    
    /// Check if user can navigate to a specific lesson
    /// - Parameters:
    ///   - lesson: The lesson to navigate to
    ///   - lessons: All lessons in the level
    ///   - progress: User's current progress
    /// - Returns: True if navigation is allowed, false otherwise
    static func canNavigateToLesson(
        _ lesson: Lesson?,
        in lessons: [Lesson],
        progress: ProgressViewModel
    ) -> Bool {
        // Defensive: Check lesson exists
        guard let lesson = lesson else {
            return false
        }
        
        // Defensive: Check lesson is valid
        guard lesson.isValid else {
            return false
        }
        
        // Defensive: Check lessons array is not empty
        guard !lessons.isEmpty else {
            return false
        }
        
        // Find lesson index
        guard let lessonIndex = lessons.firstIndex(where: { $0.id == lesson.id }) else {
            return false
        }
        
        // First lesson is always accessible
        if lessonIndex == 0 {
            return true
        }
        
        // Check if previous lesson is completed
        guard lessonIndex > 0 && lessonIndex < lessons.count else {
            return false
        }
        
        let previousLesson = lessons[lessonIndex - 1]
        return progress.isLessonCompleted(previousLesson.id)
    }
    
    // MARK: - Level Navigation Validation
    
    /// Check if user can navigate to a specific level
    /// - Parameters:
    ///   - level: The level to navigate to
    ///   - levelViewModel: Level view model with available levels
    ///   - progress: User's current progress
    /// - Returns: True if navigation is allowed, false otherwise
    static func canNavigateToLevel(
        _ level: Level?,
        levelViewModel: LevelViewModel,
        progress: ProgressViewModel
    ) -> Bool {
        // Defensive: Check level exists
        guard let level = level else {
            return false
        }
        
        // Defensive: Check level is valid
        guard level.isValid else {
            return false
        }
        
        // Defensive: Check levels are loaded
        guard levelViewModel.hasLevels else {
            return false
        }
        
        // Use LevelViewModel's validation logic
        return levelViewModel.isLevelUnlocked(level.levelNumber, progress: progress)
    }
    
    // MARK: - Track Navigation Validation
    
    /// Check if user can navigate to SwiftUI track
    /// - Parameters:
    ///   - track: The learning path to validate
    ///   - levelViewModel: Level view model
    ///   - progress: User's current progress
    /// - Returns: True if navigation is allowed, false otherwise
    static func canNavigateToTrack(
        _ track: LearningTrack,
        levelViewModel: LevelViewModel,
        progress: ProgressViewModel,
        appState: AppStateViewModel
    ) -> Bool {
        switch track {
        case .swift:
            // Swift track is always available
            return true
        case .swiftUI:
            // SwiftUI track requires Swift Level 2 completion
            return appState.isSwiftUITrackUnlocked(
                levelViewModel: levelViewModel,
                progress: progress
            )
        }
    }
    
    // MARK: - Validation Messages
    
    /// Get appropriate user message for invalid navigation
    /// - Parameters:
    ///   - lesson: Optional lesson being navigated to
    ///   - level: Optional level being navigated to
    ///   - track: Optional track being navigated to
    /// - Returns: UserMessage appropriate for the situation
    static func invalidNavigationMessage(
        lesson: Lesson? = nil,
        level: Level? = nil,
        track: LearningTrack? = nil
    ) -> UserMessage {
        if lesson != nil {
            return .lessonLocked
        } else if level != nil {
            return .levelLocked
        } else if track != nil {
            return .trackLocked
        } else {
            return .navigationError
        }
    }
}
