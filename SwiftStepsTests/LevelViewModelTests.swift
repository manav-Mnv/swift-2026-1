import XCTest
@testable import SwiftSteps

final class LevelViewModelTests: XCTestCase {

    func testLevel0IsAlwaysUnlocked() {
        let lesson = Lesson(
            id: UUID(),
            title: "Intro",
            description: "",
            content: "",
            codeChallenge: nil,
            solution: nil,
            hints: [],
            estimatedMinutes: 5
        )

        let level0 = Level(
            id: UUID(),
            levelNumber: 0,
            title: "Basics",
            description: "",
            lessons: [lesson],
            track: .swift
        )

        let progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )

        let vm = LevelViewModel(levels: [level0], userProgress: progress)

        XCTAssertTrue(vm.isLevelUnlocked(level0))
    }

    func testLevelUnlocksAfterPreviousCompleted() {
        let lesson = Lesson(
            id: UUID(),
            title: "Lesson",
            description: "",
            content: "",
            codeChallenge: nil,
            solution: nil,
            hints: [],
            estimatedMinutes: 5
        )

        let level1 = Level(
            id: UUID(),
            levelNumber: 1,
            title: "Next",
            description: "",
            lessons: [lesson],
            track: .swift
        )

        let progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [0],
            earnedBadgeIds: [],
            currentLevelNumber: 1,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )

        let vm = LevelViewModel(levels: [level1], userProgress: progress)

        XCTAssertTrue(vm.isLevelUnlocked(level1))
    }

    func testLessonUnlocksSequentially() {
        let lesson1 = Lesson(
            id: UUID(),
            title: "L1",
            description: "",
            content: "",
            codeChallenge: nil,
            solution: nil,
            hints: [],
            estimatedMinutes: 5
        )

        let lesson2 = Lesson(
            id: UUID(),
            title: "L2",
            description: "",
            content: "",
            codeChallenge: nil,
            solution: nil,
            hints: [],
            estimatedMinutes: 5
        )

        let level = Level(
            id: UUID(),
            levelNumber: 0,
            title: "Basics",
            description: "",
            lessons: [lesson1, lesson2],
            track: .swift
        )

        let progress = UserProgress(
            completedLessonIds: [lesson1.id],
            completedLevelNumbers: [],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )

        let vm = LevelViewModel(levels: [level], userProgress: progress)

        XCTAssertTrue(vm.isLessonUnlocked(lesson2, in: level))
    }

    func testLevelCompletesAfterAllLessons() {
        let lesson1 = Lesson(
            id: UUID(),
            title: "L1",
            description: "",
            content: "",
            codeChallenge: nil,
            solution: nil,
            hints: [],
            estimatedMinutes: 5
        )

        let lesson2 = Lesson(
            id: UUID(),
            title: "L2",
            description: "",
            content: "",
            codeChallenge: nil,
            solution: nil,
            hints: [],
            estimatedMinutes: 5
        )

        let level = Level(
            id: UUID(),
            levelNumber: 0,
            title: "Basics",
            description: "",
            lessons: [lesson1, lesson2],
            track: .swift
        )

        var progress = UserProgress(
            completedLessonIds: [],
            completedLevelNumbers: [],
            earnedBadgeIds: [],
            currentLevelNumber: 0,
            selectedLearningTrack: .swift,
            hasCompletedOnboarding: true
        )

        let vm = LevelViewModel(levels: [level], userProgress: progress)

        vm.markLessonCompleted(lesson1, in: level)
        vm.markLessonCompleted(lesson2, in: level)

        XCTAssertTrue(vm.isLevelCompleted(level))
    }
}
