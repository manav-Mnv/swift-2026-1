import Foundation
import SwiftUI
import Combine

final class LessonViewModel: ObservableObject {

    // MARK: - Published UI State
    @Published var userCode: String = ""
    @Published private(set) var lesson: Lesson
    @Published private(set) var runState: RunState = .idle
    @Published private(set) var outputMessage: String = ""
    @Published private(set) var isCompleted: Bool = false
    
    // Computed props for View compatibility
    var output: String { outputMessage }
    var isCorrect: Bool { runState == .success }

    // MARK: - Internal State
    private let validationService: LessonValidationService

    // MARK: - Init
    init(lesson: Lesson,
         validationService: LessonValidationService = DefaultLessonValidationService()) {
        self.lesson = lesson
        self.validationService = validationService
        self.userCode = lesson.codeChallenge ?? "" 
    }
    
    /// Convenience initializer for use in LessonListView where we don't need validation yet
    convenience init() {
        let dummyLesson = Lesson(title: "", description: "", content: "")
        self.init(lesson: dummyLesson)
    }
    
    // MARK: - Setup
    func loadLesson(_ lesson: Lesson) {
        self.lesson = lesson
        self.userCode = lesson.codeChallenge ?? ""
        self.runState = .idle
        self.outputMessage = ""
        self.isCompleted = false
    }

    // MARK: - Run / Validate
    
    func validateCode() {
        run(userCode: userCode)
    }

    func run(userCode: String) {
        runState = .running
        outputMessage = ""

        // Timeout protection (Playgrounds-safe)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }

            let result = self.validationService.validate(
                userCode: userCode,
                lesson: self.lesson
            )

            DispatchQueue.main.async {
                self.handle(result)
            }
        }
    }
    
    func showHint(index: Int) {
        // Simple implementation: Append hint to output or show alert
        // For now, let's append to output
        let hint = lesson.safeHint(at: index)
        outputMessage = "Hint: \(hint)\n\n" + outputMessage
    }

    // MARK: - Lesson State Query
    
    /// Determines the state of a lesson based on its position and user progress
    func getLessonState(_ lesson: Lesson, in lessons: [Lesson], progress: UserProgress) -> LessonState {
        // Check if completed
        if progress.completedLessonIds.contains(lesson.id) {
            return .completed
        }
        
        // Find lesson index
        guard let index = lessons.firstIndex(where: { $0.id == lesson.id }) else {
            return .locked
        }
        
        // First lesson is always available
        if index == 0 {
            return .available
        }
        
        // Check if previous lesson is completed
        let previousLesson = lessons[index - 1]
        
        if progress.completedLessonIds.contains(previousLesson.id) {
            return .available
        }
        
        return .locked
    }

    // MARK: - Completion

    private func handle(_ result: LessonValidationResult) {
        switch result {
        case .success:
            runState = .success
            outputMessage = "Nice work! You completed this lesson."
            isCompleted = true

        case .failure(let reason):
            runState = .failure
            outputMessage = reason.userMessage
        }
    }
}
