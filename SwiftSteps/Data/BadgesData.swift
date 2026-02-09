import Foundation

struct BadgesData {
    static let allBadges: [Badge] = [
        Badge(
            title: "First Steps",
            description: "Complete your first lesson",
            iconName: "star.fill",
            unlockCondition: "Complete 1 lesson",
            machineRule: .firstLesson
        ),
        Badge(
            title: "Getting Started",
            description: "Complete 3 lessons",
            iconName: "book.fill",
            unlockCondition: "Complete 3 lessons",
            machineRule: .completeLessons(count: 3)
        ),
        Badge(
            title: "Dedicated Learner",
            description: "Complete 10 lessons",
            iconName: "flame.fill",
            unlockCondition: "Complete 10 lessons",
            machineRule: .completeLessons(count: 10)
        ),
        Badge(
            title: "Level 0 Complete",
            description: "Completed your first level",
            iconName: "star.circle.fill",
            unlockCondition: "Complete Level 0",
            machineRule: .completeLevel(0)
        ),
        Badge(
            title: "Level 1 Complete",
            description: "Variables and types mastered",
            iconName: "checkmark.circle.fill",
            unlockCondition: "Complete Level 1",
            machineRule: .completeLevel(1)
        ),
        Badge(
            title: "Swift Explorer",
            description: "Started learning Swift",
            iconName: "swift",
            unlockCondition: "Select Swift learning track",
            machineRule: .completeTrack(.swift)
        ),
        Badge(
            title: "Code Master",
            description: "Complete 25 lessons",
            iconName: "crown.fill",
            unlockCondition: "Complete 25 lessons",
            machineRule: .completeLessons(count: 25)
        )
        // Add more badges as needed
    ]
}
