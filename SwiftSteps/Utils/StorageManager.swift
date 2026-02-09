import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    private let progressKey = "userProgress"
    
    private init() {}
    
    func saveProgress(_ progress: UserProgress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            userDefaults.set(encoded, forKey: progressKey)
        }
    }
    
    func loadProgress() -> UserProgress? {
        guard let data = userDefaults.data(forKey: progressKey),
              let progress = try? JSONDecoder().decode(UserProgress.self, from: data) else {
            return nil
        }
        return progress
    }
    
    func clearProgress() {
        userDefaults.removeObject(forKey: progressKey)
    }
}
