import Foundation

protocol BadgeUnlockingService {
    /// Determines which badges should be unlocked based on current user progress
    /// - Parameters:
    ///   - badges: All available badges in the system
    ///   - progress: Current user progress state
    /// - Returns: Array of badges that meet unlock criteria
    func unlockedBadges(
        badges: [Badge],
        progress: UserProgress
    ) -> [Badge]
}
