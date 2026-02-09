import Foundation

enum LessonValidationResult {
    case success
    case failure(ValidationFailure)
}

struct ValidationFailure {
    let userMessage: String
}
