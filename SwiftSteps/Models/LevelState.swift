import Foundation

/// Represents the state of a level from a user's perspective
enum LevelState {
    case locked      // User hasn't unlocked this level yet
    case unlocked    // User can access this level but hasn't completed it
    case completed   // User has completed all lessons in this level
}
