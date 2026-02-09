import Foundation
import SwiftUI

class AppStateViewModel: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var selectedLearningPath: LearningPath = .swift
    
    init() {
        // Load saved state from StorageManager
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        // Save to StorageManager
    }
    
    func selectLearningPath(_ path: LearningPath) {
        selectedLearningPath = path
        // Save to StorageManager
    }
    
    func isSwiftUITrackUnlocked(levelViewModel: LevelViewModel, progress: ProgressViewModel) -> Bool {
        // SwiftUI track unlocks when Swift Level 2 is completed
        levelViewModel.loadLevelsForPath(.swift)
        
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
}

