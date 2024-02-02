import SwiftUI

struct Reflection: Identifiable, Codable {
    var id: UUID
    let date: Date
    let heading: String
    let answers: [String]
    
    init(date: Date, heading: String, answers: [String]) {
        self.id = UUID()
        self.date = date
        self.heading = heading
        self.answers = answers
    }
}
class UserDefaultsManager {
    private static let key = "Reflections"
    
    static func saveReflections(_ reflections: [Reflection]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(reflections) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func loadReflections() -> [Reflection] {
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Reflection].self, from: data) {
                return decoded
            }
        }
        return []
    }
}
