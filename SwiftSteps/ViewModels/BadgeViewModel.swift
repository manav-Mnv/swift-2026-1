import Foundation
import SwiftUI
import Combine

final class BadgeViewModel: ObservableObject {
    
    /// Badges that have been earned during this session
    @Published private(set) var earnedBadges: [Badge] = []
    
    private let unlockingService: BadgeUnlockingService
    private(set) var userProgress: UserProgress
    private let allBadges: [Badge]
    
    init(
        allBadges: [Badge],
        userProgress: UserProgress,
        unlockingService: BadgeUnlockingService = DefaultBadgeUnlockingService()
    ) {
        self.allBadges = allBadges
        self.userProgress = userProgress
        self.unlockingService = unlockingService
        evaluateBadges()
    }
    
    /// Evaluates which badges should be unlocked based on current progress
    /// - Updates `earnedBadges` and `userProgress.earnedBadgeIds`
    /// - Safe to call multiple times (idempotent for already-earned badges)
    func evaluateBadges() {
        let newlyUnlocked = unlockingService.unlockedBadges(
            badges: allBadges,
            progress: userProgress
        )
        
        for badge in newlyUnlocked {
            // Only add if not already earned
            if !userProgress.earnedBadgeIds.contains(badge.id) {
                userProgress.earnedBadgeIds.insert(badge.id)
                earnedBadges.append(badge)
            }
        }
    }
    
    /// Update internal progress reference and re-evaluate badges
    /// - Parameter progress: New progress state
    /// - Note: Call this after progress changes (e.g., lesson completion)
    func updateProgress(_ progress: UserProgress) {
        self.userProgress = progress
        evaluateBadges()
    }
    
    /// Get all badges that have been earned historically
    func getAllEarnedBadges() -> [Badge] {
        allBadges.filter { userProgress.earnedBadgeIds.contains($0.id) }
    }
    
    /// Get all badges that are still locked
    func getLockedBadges() -> [Badge] {
        allBadges.filter { !userProgress.earnedBadgeIds.contains($0.id) }
    }
}
