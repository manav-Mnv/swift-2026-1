import Foundation

/// Human-friendly messages for various app states
/// All messages maintain a calm, encouraging tone suitable for beginner learners
enum UserMessage {
    // MARK: - Empty States
    case noLessonsAvailable
    case noLevelsAvailable
    case noProgressYet
    case noBadgesYet
    
    // MARK: - Locked Content
    case lessonLocked
    case levelLocked
    case trackLocked
    
    // MARK: - Validation States
    case codeNotReady
    case codeIncorrect
    case codeCorrect
    case emptyCodeEditor
    case noCodeChange
    
    // MARK: - Error Recovery
    case lessonNotFound
    case levelNotFound
    case navigationError
    
    // MARK: - Loading States
    case loading
    
    var message: String {
        switch self {
        // Empty States
        case .noLessonsAvailable:
            return "No lessons are available yet. Check back soon!"
        case .noLevelsAvailable:
            return "No levels to show right now. This is where your learning journey begins!"
        case .noProgressYet:
            return "Ready to start learning? Your journey begins with the first lesson."
        case .noBadgesYet:
            return "Complete lessons to earn your first badge!"
        
        // Locked Content
        case .lessonLocked:
            return "Complete the previous lesson to unlock this one."
        case .levelLocked:
            return "Complete the previous level to unlock this one."
        case .trackLocked:
            return "Complete Swift Level 2 to unlock the SwiftUI track."
        
        // Validation States
        case .codeNotReady:
            return "Give it a try! Write some code and tap Run when you're ready."
        case .codeIncorrect:
            return "Not quite right yet. Take another look at the lesson and try again. You're doing great!"
        case .codeCorrect:
            return "✓ Perfect! Your code is correct.\n\nGreat job! You've completed this lesson."
        case .emptyCodeEditor:
            return "Looks like the code editor is empty. Try adding some Swift code!"
        case .noCodeChange:
            return "The code looks the same. Try making a change first!"
        
        // Error Recovery
        case .lessonNotFound:
            return "We couldn't find that lesson. Let's head back and try again."
        case .levelNotFound:
            return "We couldn't find that level. Let's return to the home screen."
        case .navigationError:
            return "Something unexpected happened. Let's start fresh from the home screen."
        
        // Loading
        case .loading:
            return "Loading..."
        }
    }
    
    var icon: String {
        switch self {
        case .noLessonsAvailable, .noLevelsAvailable:
            return "book.closed"
        case .noProgressYet:
            return "checkmark.circle"
        case .noBadgesYet:
            return "star"
        case .lessonLocked, .levelLocked, .trackLocked:
            return "lock.fill"
        case .codeCorrect:
            return "checkmark.circle.fill"
        case .codeIncorrect, .codeNotReady, .emptyCodeEditor, .noCodeChange:
            return "lightbulb"
        case .lessonNotFound, .levelNotFound, .navigationError:
            return "arrow.uturn.backward"
        case .loading:
            return "hourglass"
        }
    }
}
