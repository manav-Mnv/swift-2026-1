import Foundation
import SwiftUI

enum LessonState {
    case locked
    case available
    case completed
}

class LessonViewModel: ObservableObject {
    @Published var currentLesson: Lesson?
    @Published var userCode: String = ""
    @Published var output: String = ""
    @Published var isCorrect: Bool = false
    @Published var isExecuting: Bool = false
    
    private var initialCode: String = ""
    private var currentHintIndex: Int = 0
    
    func loadLesson(_ lesson: Lesson) {
        // Validate lesson before loading
        guard lesson.isValid else {
            currentLesson = nil
            output = UserMessage.lessonNotFound.message
            isCorrect = false
            return
        }
        
        currentLesson = lesson
        userCode = lesson.codeChallenge
        initialCode = lesson.codeChallenge
        output = ""
        isCorrect = false
        isExecuting = false
        currentHintIndex = 0
    }
    
    func validateCode() {
        // Defensive: Check lesson exists
        guard let lesson = currentLesson else {
            output = UserMessage.lessonNotFound.message
            isCorrect = false
            return
        }
        
        // Prevent execution while already executing
        guard !isExecuting else {
            return
        }
        
        // Check for empty code
        let trimmedCode = userCode.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedCode.isEmpty {
            output = UserMessage.emptyCodeEditor.message
            isCorrect = false
            return
        }
        
        // Check if code changed from initial state
        if trimmedCode == initialCode.trimmingCharacters(in: .whitespacesAndNewlines) 
           && !isCorrect { // Allow re-running if already correct
            output = UserMessage.codeNotReady.message
            isCorrect = false
            return
        }
        
        // Set executing state to prevent rapid taps
        isExecuting = true
        
        // Simple validation: check if user code matches solution
        // In a real implementation, this would compile and run the code
        let cleanedUserCode = trimmedCode
        let cleanedSolution = lesson.solution.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Simulate brief execution delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            if cleanedUserCode == cleanedSolution {
                self.isCorrect = true
                self.output = UserMessage.codeCorrect.message
            } else {
                self.isCorrect = false
                self.output = UserMessage.codeIncorrect.message
            }
            
            self.isExecuting = false
        }
    }
    
    func showHint(index: Int) {
        guard let lesson = currentLesson else {
            output = UserMessage.lessonNotFound.message
            return
        }
        
        // Use safe hint access from Lesson model
        let hint = lesson.safeHint(at: index)
        output = "💡 Hint: \(hint)"
        
        // Store current hint index for progressive hints
        currentHintIndex = min(index + 1, lesson.hintCount)
    }
    
    func showNextHint() {
        showHint(index: currentHintIndex)
    }
    
    func isLessonAvailable(_ lesson: Lesson, in lessons: [Lesson], progress: ProgressViewModel) -> Bool {
        // Defensive: Check lesson is in the lessons array
        guard let lessonIndex = lessons.firstIndex(where: { $0.id == lesson.id }) else {
            return false
        }
        
        // First lesson is always available
        if lessonIndex == 0 {
            return true
        }
        
        // Defensive: Validate previous lesson index
        guard lessonIndex > 0 && lessonIndex < lessons.count else {
            return false
        }
        
        // Check if previous lesson is completed
        let previousLesson = lessons[lessonIndex - 1]
        return progress.isLessonCompleted(previousLesson.id)
    }
    
    func getLessonState(_ lesson: Lesson, in lessons: [Lesson], progress: ProgressViewModel) -> LessonState {
        if progress.isLessonCompleted(lesson.id) {
            return .completed
        } else if isLessonAvailable(lesson, in: lessons, progress: progress) {
            return .available
        } else {
            return .locked
        }
    }
    
    // MARK: - Safety Helpers
    
    /// Check if there's a lesson loaded
    var hasLesson: Bool {
        return currentLesson != nil
    }
    
    /// Reset to initial state
    func reset() {
        currentLesson = nil
        userCode = ""
        initialCode = ""
        output = ""
        isCorrect = false
        isExecuting = false
        currentHintIndex = 0
    }
}

