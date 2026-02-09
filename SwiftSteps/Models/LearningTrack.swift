import Foundation

/// Represents a distinct learning path or subject area
enum LearningTrack: String, Codable, CaseIterable, Identifiable, Hashable {
    case swift
    case swiftUI
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .swift: return "Swift Language"
        case .swiftUI: return "SwiftUI Framework"
        }
    }
}
