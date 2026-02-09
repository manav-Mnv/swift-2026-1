import Foundation

/// Represents the state of a lesson from a user's perspective
enum LessonState {
    case locked      // User hasn't unlocked this lesson yet
    case available   // User can access this lesson
    case completed   // User has completed this lesson
}
