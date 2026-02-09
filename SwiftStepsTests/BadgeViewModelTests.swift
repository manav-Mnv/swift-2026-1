import XCTest
@testable import SwiftSteps

final class BadgeViewModelTests: XCTestCase {
    
    // MARK: - Level Completion Badge Tests
    
    func testUnlockBadgeOnLevelCompletion() {
        // Given: A badge that unlocks on level 0 completion
        let badge = Badge(
            id: UUID(),
            title: "First Level",
            description: "Completed Level 0",
            iconName: "star.fill",
            unlockCondition: "Complete Level 0",
            machineRule: .completeLevel(0)
        )
        
        // And: Progress shows level 0 is complete
        let progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [0],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        // When: ViewModel is initialized
        let vm = BadgeViewModel(
            allBadges: [badge],
            userProgress: progress
        )
        
        // Then: Badge is unlocked
        XCTAssertEqual(vm.earnedBadges.count, 1, "Should unlock one badge")
        XCTAssertTrue(vm.earnedBadges.contains { $0.id == badge.id }, "Should contain the specific badge")
        XCTAssertTrue(vm.userProgress.earnedBadgeIds.contains(badge.id), "Badge should be marked as earned in progress")
    }
    
    func testDoNotUnlockBadgeWhenLevelNotComplete() {
        // Given: A badge that requires level 0
        let badge = Badge(
            id: UUID(),
            title: "First Level",
            description: "Completed Level 0",
            iconName: "star.fill",
            unlockCondition: "Complete Level 0",
            machineRule: .completeLevel(0)
        )
        
        // And: Progress shows no levels complete
        let progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        // When: ViewModel is initialized
        let vm = BadgeViewModel(
            allBadges: [badge],
            userProgress: progress
        )
        
        // Then: No badges are unlocked
        XCTAssertEqual(vm.earnedBadges.count, 0, "Should not unlock any badges")
        XCTAssertFalse(vm.userProgress.earnedBadgeIds.contains(badge.id), "Badge should not be marked as earned")
    }
    
    // MARK: - Lesson Count Badge Tests
    
    func testUnlockBadgeOnLessonCount() {
        // Given: A badge that unlocks after 3 lessons
        let badge = Badge(
            id: UUID(),
            title: "Getting Started",
            description: "Completed 3 lessons",
            iconName: "bolt.fill",
            unlockCondition: "Complete 3 lessons",
            machineRule: .completeLessons(count: 3)
        )
        
        // And: Progress shows 3 lessons complete
        let progress = UserProgress(
            completedLessonIds: [UUID(), UUID(), UUID()],
            completedLevelNumbers: [],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        // When: ViewModel is initialized
        let vm = BadgeViewModel(
            allBadges: [badge],
            userProgress: progress
        )
        
        // Then: Badge is unlocked
        XCTAssertEqual(vm.earnedBadges.count, 1, "Should unlock one badge")
        XCTAssertTrue(vm.earnedBadges.contains { $0.id == badge.id }, "Should contain the lesson count badge")
    }
    
    func testUnlockBadgeWithMoreThanRequiredLessons() {
        // Given: A badge requiring 3 lessons
        let badge = Badge(
            id: UUID(),
            title: "Getting Started",
            description: "Completed 3 lessons",
            iconName: "bolt.fill",
            unlockCondition: "Complete 3 lessons",
            machineRule: .completeLessons(count: 3)
        )
        
        // And: Progress shows 5 lessons complete (more than required)
        let progress = UserProgress(
            completedLessonIds: [UUID(), UUID(), UUID(), UUID(), UUID()],
            completedLevelNumbers: [],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        // When: ViewModel is initialized
        let vm = BadgeViewModel(
            allBadges: [badge],
            userProgress: progress
        )
        
        // Then: Badge is still unlocked
        XCTAssertEqual(vm.earnedBadges.count, 1, "Should unlock badge when exceeding requirement")
    }
    
    // MARK: - First Lesson Badge Tests
    
    func testUnlockFirstLessonBadge() {
        // Given: A badge for completing the first lesson
        let badge = Badge(
            id: UUID(),
            title: "First Steps",
            description: "Completed your first lesson",
            iconName: "figure.walk",
            unlockCondition: "Complete your first lesson",
            machineRule: .firstLesson
        )
        
        // And: Progress shows one lesson complete
        let progress = UserProgress(
            completedLessonIds: [UUID()],
            completedLevelNumbers: [],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        // When: ViewModel is initialized
        let vm = BadgeViewModel(
            allBadges: [badge],
            userProgress: progress
        )
        
        // Then: Badge is unlocked
        XCTAssertEqual(vm.earnedBadges.count, 1, "Should unlock first lesson badge")
    }
    
    // MARK: - Multiple Badges Tests
    
    func testUnlockMultipleBadgesSimultaneously() {
        // Given: Multiple badges with different rules
        let levelBadge = Badge(
            id: UUID(),
            title: "Level Master",
            description: "Completed Level 0",
            iconName: "star.fill",
            unlockCondition: "Complete Level 0",
            machineRule: .completeLevel(0)
        )
        
        let lessonBadge = Badge(
            id: UUID(),
            title: "Eager Learner",
            description: "Completed 2 lessons",
            iconName: "book.fill",
            unlockCondition: "Complete 2 lessons",
            machineRule: .completeLessons(count: 2)
        )
        
        // And: Progress meets both criteria
        let progress = UserProgress(
            completedLessonIds: [UUID(), UUID()],
            completedLevelNumbers: [0],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        // When: ViewModel is initialized
        let vm = BadgeViewModel(
            allBadges: [levelBadge, lessonBadge],
            userProgress: progress
        )
        
        // Then: Both badges are unlocked
        XCTAssertEqual(vm.earnedBadges.count, 2, "Should unlock both badges")
        XCTAssertTrue(vm.earnedBadges.contains { $0.id == levelBadge.id }, "Should contain level badge")
        XCTAssertTrue(vm.earnedBadges.contains { $0.id == lessonBadge.id }, "Should contain lesson badge")
    }
    
    // MARK: - Idempotency Tests
    
    func testBadgeUnlocksOnlyOnce() {
        // Given: A badge and initial progress that meets criteria
        let badge = Badge(
            id: UUID(),
            title: "First Level",
            description: "Completed Level 0",
            iconName: "star.fill",
            unlockCondition: "Complete Level 0",
            machineRule: .completeLevel(0)
        )
        
        var progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [0],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        // When: ViewModel is initialized
        let vm = BadgeViewModel(
            allBadges: [badge],
            userProgress: progress
        )
        
        // Then: Badge is earned once
        XCTAssertEqual(vm.earnedBadges.count, 1, "Should earn badge once")
        
        // When: We call evaluateBadges again
        vm.evaluateBadges()
        
        // Then: Badge count doesn't increase
        XCTAssertEqual(vm.earnedBadges.count, 1, "Should still have only one badge (not duplicated)")
    }
    
    func testBadgeDoesNotUnlockIfAlreadyEarned() {
        // Given: A badge and progress that already has it earned
        let badgeId = UUID()
        let badge = Badge(
            id: badgeId,
            title: "First Level",
            description: "Completed Level 0",
            iconName: "star.fill",
            unlockCondition: "Complete Level 0",
            machineRule: .completeLevel(0)
        )
        
        let progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [0],
            earnedBadgeIds: [badgeId], // Already earned
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        // When: ViewModel is initialized
        let vm = BadgeViewModel(
            allBadges: [badge],
            userProgress: progress
        )
        
        // Then: Badge is not added to earnedBadges (it was already earned)
        XCTAssertEqual(vm.earnedBadges.count, 0, "Should not add already-earned badge to new earnings")
        XCTAssertTrue(vm.userProgress.earnedBadgeIds.contains(badgeId), "Badge should remain in earned set")
    }
    
    // MARK: - Progress Update Tests
    
    func testUpdateProgressTriggersNewBadgeEvaluation() {
        // Given: A badge requiring level 1
        let badge = Badge(
            id: UUID(),
            title: "Second Level",
            description: "Completed Level 1",
            iconName: "star.fill",
            unlockCondition: "Complete Level 1",
            machineRule: .completeLevel(1)
        )
        
        // And: Initial progress with no levels complete
        var progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        let vm = BadgeViewModel(
            allBadges: [badge],
            userProgress: progress
        )
        
        // Then: No badges earned initially
        XCTAssertEqual(vm.earnedBadges.count, 0, "Should have no badges initially")
        
        // When: Progress is updated with level 1 complete
        progress.completedLevelNumbers.insert(1)
        vm.updateProgress(progress)
        
        // Then: Badge is now unlocked
        XCTAssertEqual(vm.earnedBadges.count, 1, "Should unlock badge after progress update")
        XCTAssertTrue(vm.earnedBadges.contains { $0.id == badge.id }, "Should contain the level 1 badge")
    }
    
    // MARK: - Helper Methods Tests
    
    func testGetAllEarnedBadges() {
        // Given: Multiple badges, some earned
        let earnedBadge1Id = UUID()
        let earnedBadge2Id = UUID()
        let lockedBadgeId = UUID()
        
        let earnedBadge1 = Badge(
            id: earnedBadge1Id,
            title: "Earned 1",
            description: "Description",
            iconName: "star.fill",
            unlockCondition: "Complete Level 0",
            machineRule: .completeLevel(0)
        )
        
        let earnedBadge2 = Badge(
            id: earnedBadge2Id,
            title: "Earned 2",
            description: "Description",
            iconName: "bolt.fill",
            unlockCondition: "Complete 1 lesson",
            machineRule: .completeLessons(count: 1)
        )
        
        let lockedBadge = Badge(
            id: lockedBadgeId,
            title: "Locked",
            description: "Description",
            iconName: "lock.fill",
            unlockCondition: "Complete Level 5",
            machineRule: .completeLevel(5)
        )
        
        let progress = UserProgress(
            completedLessonIds: [UUID()],
            completedLevelNumbers: [0],
            earnedBadgeIds: [earnedBadge1Id, earnedBadge2Id],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        let vm = BadgeViewModel(
            allBadges: [earnedBadge1, earnedBadge2, lockedBadge],
            userProgress: progress
        )
        
        // When: Getting all earned badges
        let allEarned = vm.getAllEarnedBadges()
        
        // Then: Only earned badges are returned
        XCTAssertEqual(allEarned.count, 2, "Should return 2 earned badges")
        XCTAssertTrue(allEarned.contains { $0.id == earnedBadge1Id })
        XCTAssertTrue(allEarned.contains { $0.id == earnedBadge2Id })
        XCTAssertFalse(allEarned.contains { $0.id == lockedBadgeId })
    }
    
    func testGetLockedBadges() {
        // Given: Multiple badges, some locked
        let earnedBadgeId = UUID()
        let lockedBadge1Id = UUID()
        let lockedBadge2Id = UUID()
        
        let earnedBadge = Badge(
            id: earnedBadgeId,
            title: "Earned",
            description: "Description",
            iconName: "star.fill",
            unlockCondition: "Complete Level 0",
            machineRule: .completeLevel(0)
        )
        
        let lockedBadge1 = Badge(
            id: lockedBadge1Id,
            title: "Locked 1",
            description: "Description",
            iconName: "lock.fill",
            unlockCondition: "Complete Level 5",
            machineRule: .completeLevel(5)
        )
        
        let lockedBadge2 = Badge(
            id: lockedBadge2Id,
            title: "Locked 2",
            description: "Description",
            iconName: "lock.fill",
            unlockCondition: "Complete 100 lessons",
            machineRule: .completeLessons(count: 100)
        )
        
        let progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [0],
            earnedBadgeIds: [earnedBadgeId],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )
        
        let vm = BadgeViewModel(
            allBadges: [earnedBadge, lockedBadge1, lockedBadge2],
            userProgress: progress
        )
        
        // When: Getting locked badges
        let locked = vm.getLockedBadges()
        
        // Then: Only locked badges are returned
        XCTAssertEqual(locked.count, 2, "Should return 2 locked badges")
        XCTAssertTrue(locked.contains { $0.id == lockedBadge1Id })
        XCTAssertTrue(locked.contains { $0.id == lockedBadge2Id })
        XCTAssertFalse(locked.contains { $0.id == earnedBadgeId })
    }
}
