import Foundation
import Combine

final class LessonViewModel: ObservableObject {

    // MARK: - Published UI State
    @Published private(set) var lesson: Lesson
    @Published private(set) var runState: RunState = .idle
    @Published private(set) var outputMessage: String = ""
    @Published private(set) var isCompleted: Bool = false

    // MARK: - Internal State
    private let validationService: LessonValidationService

    // MARK: - Init
    init(lesson: Lesson,
         validationService: LessonValidationService = DefaultLessonValidationService()) {
        self.lesson = lesson
        self.validationService = validationService
    }
    
    /// Convenience initializer for use in LessonListView where we don't need validation yet
    convenience init() {
        let dummyLesson = Lesson(title: "", description: "", content: "")
        self.init(lesson: dummyLesson)
    }

    // MARK: - Run / Validate

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

    // MARK: - Lesson State Query
    
    /// Determines the state of a lesson based on its position and user progress
    func getLessonState(_ lesson: Lesson, in lessons: [Lesson], progress: ProgressViewModel) -> LessonState {
        // Check if completed
        if progress.isLessonCompleted(lesson.id) {
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
        if progress.isLessonCompleted(previousLesson.id) {
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
