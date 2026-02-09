import Foundation

struct Badge: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let iconName: String
    let unlockCondition: String
    
    init(id: UUID = UUID(), title: String, description: String, iconName: String, unlockCondition: String) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.unlockCondition = unlockCondition
    }
}
