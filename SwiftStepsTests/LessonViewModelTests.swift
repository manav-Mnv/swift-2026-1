import XCTest
@testable import SwiftSteps

final class LessonViewModelTests: XCTestCase {

    func testTheoryLessonCompletesImmediately() {
        let lesson = Lesson(
            id: UUID(),
            title: "Intro",
            description: "",
            content: "",
            codeChallenge: nil,
            solution: nil,
            hints: [],
            estimatedMinutes: 3
        )

        let vm = LessonViewModel(lesson: lesson)

        vm.run(userCode: "")

        XCTAssertTrue(vm.isCompleted)
    }

    func testCorrectCodeCompletesLesson() {
        let lesson = Lesson(
            id: UUID(),
            title: "Variables",
            description: "",
            content: "",
            codeChallenge: "let a = 5",
            solution: "let a = 5",
            hints: [],
            estimatedMinutes: 5
        )

        let vm = LessonViewModel(lesson: lesson)

        vm.run(userCode: " let a = 5 ")

        XCTAssertTrue(vm.isCompleted)
        XCTAssertEqual(vm.runState, .success)
    }

    func testIncorrectCodeFailsGracefully() {
        let lesson = Lesson(
            id: UUID(),
            title: "Variables",
            description: "",
            content: "",
            codeChallenge: "let a = 5",
            solution: "let a = 5",
            hints: [],
            estimatedMinutes: 5
        )

        let vm = LessonViewModel(lesson: lesson)

        vm.run(userCode: "var a = 5")

        XCTAssertFalse(vm.isCompleted)
        XCTAssertEqual(vm.runState, .failure)
    }
}
