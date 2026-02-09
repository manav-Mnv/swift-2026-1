import Foundation

struct Level: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let lessons: [Lesson]
    let levelNumber: Int
    
    init(id: UUID = UUID(), title: String, description: String, lessons: [Lesson], levelNumber: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.lessons = lessons
        self.levelNumber = max(0, levelNumber) // Ensure non-negative
    }
    
    // MARK: - Safety & Validation
    
    /// Check if level has any lessons
    var hasLessons: Bool {
        return !lessons.isEmpty
    }
    
    /// Safe count of lessons
    var lessonCount: Int {
        return lessons.count
    }
    
    /// Check if level is valid (has lessons and valid data)
    var isValid: Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               hasLessons &&
               levelNumber >= 0
    }
    
    /// Get lesson at index safely
    /// - Parameter index: The index of the lesson
    /// - Returns: The lesson if it exists, nil otherwise
    func safeLesson(at index: Int) -> Lesson? {
        guard index >= 0 && index < lessons.count else {
            return nil
        }
        return lessons[index]
    }
}
