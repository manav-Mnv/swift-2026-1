import Foundation

struct Lesson: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let content: String
    let codeChallenge: String
    let solution: String
    let hints: [String]
    
    init(id: UUID = UUID(), title: String, description: String, content: String, codeChallenge: String, solution: String, hints: [String] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.content = content
        self.codeChallenge = codeChallenge
        self.solution = solution
        self.hints = hints
    }
    
    // MARK: - Safety & Validation
    
    /// Check if lesson has valid content
    var isValid: Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !codeChallenge.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Check if lesson has any hints
    var hasHints: Bool {
        return !hints.isEmpty
    }
    
    /// Get hint at index safely without crashing
    /// - Parameter index: The index of the hint to retrieve
    /// - Returns: The hint if it exists, or a default message
    func safeHint(at index: Int) -> String {
        guard index >= 0 && index < hints.count else {
            return "No more hints available. You've got this!"
        }
        return hints[index]
    }
    
    /// Number of available hints
    var hintCount: Int {
        return hints.count
    }
}
