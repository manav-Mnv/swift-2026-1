import Foundation
import SwiftUI
import Combine

final class AppStateViewModel: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var selectedLearningTrack: LearningTrack = .swift
    @Published var navigationPath: [NavigationRoute] = []
    
    let levelViewModel: LevelViewModel
    let badgeViewModel: BadgeViewModel
    
    init() {
        let levels = SampleData.levels   // replace with JSON loader later
        let badges = BadgesData.allBadges
        let progress = UserProgress.default
        
        self.levelViewModel = LevelViewModel(
            levels: levels,
            userProgress: progress
        )
        
        self.badgeViewModel = BadgeViewModel(
            allBadges: badges,
            userProgress: progress
        )
        
        // Load saved state from StorageManager
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        // Save to StorageManager
    }
    
    func selectLearningTrack(_ track: LearningTrack) {
        selectedLearningTrack = track
        // Save to StorageManager
    }
    
    func isSwiftUITrackUnlocked(levelViewModel: LevelViewModel, progress: ProgressViewModel) -> Bool {
        // SwiftUI track unlocks when Swift Level 2 is completed
        levelViewModel.loadLevelsForTrack(.swift)
        
        // Defensive: Check if levels loaded successfully
        guard !levelViewModel.availableLevels.isEmpty else {
            return false
        }
        
        // Defensive: Check if Swift Level 2 exists
        guard let swiftLevel2 = levelViewModel.availableLevels.first(where: { $0.levelNumber == 2 }) else {
            return false
        }
        
        // Defensive: Validate level has lessons before checking completion
        guard swiftLevel2.hasLessons else {
            return false
        }
        
        return levelViewModel.isLevelCompleted(swiftLevel2, progress: progress)
    }
    
    // MARK: - Navigation Actions
    
    func goToLevels() {
        navigationPath.append(.levelSelection)
    }
    
    func goToLessons(for level: Level) {
        navigationPath.append(.lessonList(level))
    }
    
    func goToLesson(_ lesson: Lesson) {
        navigationPath.append(.lessonDetail(lesson))
    }
    
    func goHome() {
        navigationPath.removeAll()
    }
}


