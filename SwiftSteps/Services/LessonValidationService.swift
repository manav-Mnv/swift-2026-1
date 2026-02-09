import Foundation

protocol LessonValidationService {
    func validate(userCode: String, lesson: Lesson) -> LessonValidationResult
}
