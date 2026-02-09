import Foundation

final class DefaultLessonValidationService: LessonValidationService {

    func validate(userCode: String, lesson: Lesson) -> LessonValidationResult {

        guard let solution = lesson.solution else {
            // Theory-only lesson
            return .success
        }

        let normalizedUserCode = normalize(userCode)
        let normalizedSolution = normalize(solution)

        if normalizedUserCode.contains(normalizedSolution) {
            return .success
        }

        return .failure(
            ValidationFailure(
                userMessage: "Almost there. Try checking your syntax or logic."
            )
        )
    }

    private func normalize(_ code: String) -> String {
        code
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .lowercased()
    }
}
