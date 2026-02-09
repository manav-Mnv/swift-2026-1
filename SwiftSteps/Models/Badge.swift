import Foundation

struct Badge: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let iconName: String
    
    /// Human-readable explanation (UI)
    let unlockCondition: String
    
    /// Optional machine-readable rule (logic)
    let machineRule: BadgeRule?
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        iconName: String,
        unlockCondition: String,
        machineRule: BadgeRule? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.unlockCondition = unlockCondition
        self.machineRule = machineRule
    }
}

enum BadgeRule: Codable, Equatable {
    case completeLevel(Int)
    case completeLessons(count: Int)
    case completeTrack(LearningTrack)
    case firstLesson
    case streakDays(Int)
    
    // MARK: - Codable Implementation
    
    private enum CodingKeys: String, CodingKey {
        case type
        case levelNumber
        case lessonCount
        case track
        case streakDays
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "completeLevel":
            let levelNumber = try container.decode(Int.self, forKey: .levelNumber)
            self = .completeLevel(levelNumber)
        case "completeLessons":
            let count = try container.decode(Int.self, forKey: .lessonCount)
            self = .completeLessons(count: count)
        case "completeTrack":
            let track = try container.decode(LearningTrack.self, forKey: .track)
            self = .completeTrack(track)
        case "firstLesson":
            self = .firstLesson
        case "streakDays":
            let days = try container.decode(Int.self, forKey: .streakDays)
            self = .streakDays(days)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown badge rule type: \(type)"
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .completeLevel(let levelNumber):
            try container.encode("completeLevel", forKey: .type)
            try container.encode(levelNumber, forKey: .levelNumber)
        case .completeLessons(let count):
            try container.encode("completeLessons", forKey: .type)
            try container.encode(count, forKey: .lessonCount)
        case .completeTrack(let track):
            try container.encode("completeTrack", forKey: .type)
            try container.encode(track, forKey: .track)
        case .firstLesson:
            try container.encode("firstLesson", forKey: .type)
        case .streakDays(let days):
            try container.encode("streakDays", forKey: .type)
            try container.encode(days, forKey: .streakDays)
        }
    }
}
