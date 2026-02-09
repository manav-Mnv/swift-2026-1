import Foundation
import SwiftUI
import Combine

final class AppStateViewModel: ObservableObject {
    // MARK: - Published State
    @Published var hasCompletedOnboarding: Bool = false {
        didSet {
            userProgress.hasCompletedOnboarding = hasCompletedOnboarding
            saveProgress()
        }
    }
    
    @Published var selectedLearningTrack: LearningTrack = .swift {
        didSet {
            userProgress.selectedLearningTrack = selectedLearningTrack
            saveProgress()
        }
    }
    
    @Published var navigationPath: [NavigationRoute] = []
    
    // Primary Source of Truth
    @Published private(set) var userProgress: UserProgress
    
    // Child ViewModels
    let levelViewModel: LevelViewModel
    let badgeViewModel: BadgeViewModel
    
    // Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 1. Load data
        let levels = SampleData.levels
        let badges = BadgesData.allBadges
        
        // 2. Load saved progress or default
        if let savedProgress = StorageManager.shared.loadProgress() {
            self.userProgress = savedProgress
        } else {
            self.userProgress = UserProgress.default
        }
        
        // 3. Initialize Published properties from progress
        self.hasCompletedOnboarding = self.userProgress.hasCompletedOnboarding
        self.selectedLearningTrack = self.userProgress.selectedLearningTrack
        
        // 4. Initialize Child ViewModels with initial progress
        self.levelViewModel = LevelViewModel(
            levels: levels,
            userProgress: self.userProgress
        )
        
        self.badgeViewModel = BadgeViewModel(
            allBadges: badges,
            userProgress: self.userProgress
        )
        
        // 5. Setup Synchronization
        setupBindings()
    }
    
    private func setupBindings() {
        // Listen for updates from LevelViewModel
        levelViewModel.$userProgress
            .dropFirst()
            .sink { [weak self] newProgress in
                guard let self = self else { return }
                self.updateProgress(newProgress)
            }
            .store(in: &cancellables)
            
        // Listen for updates from BadgeViewModel (if it modifies progress directly)
         badgeViewModel.$userProgress
            .dropFirst()
            .sink { [weak self] newProgress in
                guard let self = self else { return }
                self.updateProgress(newProgress)
            }
            .store(in: &cancellables)
    }
    
    // Centralized progress update method
    private func updateProgress(_ newProgress: UserProgress) {
        // Update local source of truth
        self.userProgress = newProgress
        
        // Sync back to child view models if needed to avoid loops
        if levelViewModel.userProgress.completedLessonIds != newProgress.completedLessonIds ||
           levelViewModel.userProgress.completedLevelNumbers != newProgress.completedLevelNumbers {
             levelViewModel.updateProgress(newProgress)
        }
        
        if badgeViewModel.userProgress.earnedBadgeIds != newProgress.earnedBadgeIds {
            badgeViewModel.updateProgress(newProgress)
        }
        
        // Save to disk
        saveProgress()
    }

    private func saveProgress() {
        StorageManager.shared.saveProgress(userProgress)
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true 
        // Side effect handled by didSet
    }
    
    func selectLearningTrack(_ track: LearningTrack) {
        selectedLearningTrack = track
        // Side effect handled by didSet
    }
    
    func isSwiftUITrackUnlocked() -> Bool {
         // SwiftUI track unlocks when Swift Level 2 is completed
        guard let swiftLevel2 = levelViewModel.levels.first(where: { $0.levelNumber == 2 }) else {
            return false
        }
        return userProgress.completedLevelNumbers.contains(swiftLevel2.levelNumber)
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


