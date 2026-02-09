import Foundation

struct Level: Identifiable, Codable {
    let id: UUID
    let levelNumber: Int
    let title: String
    let description: String
    let lessons: [Lesson]
    let track: LearningTrack
    
    init(
        id: UUID = UUID(),
        levelNumber: Int,
        title: String,
        description: String,
        lessons: [Lesson],
        track: LearningTrack
    ) {
        self.id = id
        self.levelNumber = max(0, levelNumber) // Ensure non-negative
        self.title = title
        self.description = description
        self.lessons = lessons
        self.track = track
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
    
    /// Total estimated time for all lessons
    var totalEstimatedMinutes: Int {
        return lessons.reduce(0) { $0 + $1.estimatedMinutes }
    }
}

enum LearningTrack: String, Codable {
    case swift
    case swiftUI
}
