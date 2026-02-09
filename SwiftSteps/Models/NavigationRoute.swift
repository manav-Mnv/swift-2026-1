import Foundation

/// Type-safe navigation routes for the app
enum NavigationRoute: Hashable {
    case levelSelection
    case lessonList(Level)
    case lessonDetail(Lesson)
}
