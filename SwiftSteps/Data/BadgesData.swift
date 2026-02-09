import Foundation

struct BadgesData {
    static let allBadges: [Badge] = [
        Badge(
            title: "First Steps",
            description: "Complete your first lesson",
            iconName: "star.fill",
            unlockCondition: "Complete 1 lesson"
        ),
        Badge(
            title: "Quick Learner",
            description: "Complete a level in one session",
            iconName: "bolt.fill",
            unlockCondition: "Complete a level without closing the app"
        ),
        Badge(
            title: "Code Master",
            description: "Complete all lessons in a learning path",
            iconName: "crown.fill",
            unlockCondition: "Complete all lessons in Swift or SwiftUI"
        )
        // Add more badges as needed
    ]
}
