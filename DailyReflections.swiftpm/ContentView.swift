import SwiftUI

struct ContentView: View {
    @State private var reflections: [Reflection] = UserDefaultsManager.loadReflections()
    @State private var questions = ["Question 1", "Question 2", "Question 3", "Question 4", "Question 5"]
    @State private var answers = Array(repeating: "", count: 5)
    @State private var heading = ""
    @State private var isSaved = true // Set initially to true
    
    var allQuestionsAnswered: Bool {
        for answer in answers {
            if answer.isEmpty {
                return false
            }
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Enter Reflection")) {
                        TextField("Heading", text: $heading)
                        ForEach(0..<5, id: \.self) { index in
                            TextField(questions[index], text: $answers[index])
                        }
                    }
                }
                
                Button("Submit") {
                    saveReflection()
                }
                .padding()
                .disabled(!allQuestionsAnswered) // Disable the button if not all questions are answered
                
                if isSaved {
                    NavigationLink(destination: SavedReflectionsView(reflections: $reflections)) {
                        Text("View Saved Reflections")
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Reflection App")
        }
    }
    
    func saveReflection() {
        let reflection = Reflection(date: Date(), heading: heading, answers: answers)
        reflections.append(reflection)
        heading = ""
        answers = Array(repeating: "", count: 5)
        isSaved = true // Update isSaved to true
        
        // Save reflections to UserDefaults
        UserDefaultsManager.saveReflections(reflections)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SavedReflectionsView: View {
    @Binding var reflections: [Reflection]
    
    var body: some View {
        List(reflections) { reflection in
            NavigationLink(destination: ReflectionDetailView(reflections: $reflections, reflection: reflection)) {
                VStack(alignment: .leading) {
                    Text(reflection.heading)
                        .font(.headline)
                    Text("\(reflection.date)")
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("Saved Reflections")
    }
}


struct ReflectionDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var reflections: [Reflection]
    var reflection: Reflection
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Reflection Details")
                .font(.title)
                .padding()
            
            Text("Heading: \(reflection.heading)")
                .padding(.horizontal)
            
            ForEach(0..<reflection.answers.count, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text("Question \(index + 1)")
                        .font(.headline)
                        .padding(.horizontal)
                    Text(reflection.answers[index])
                        .padding(.horizontal)
                }
            }
            
            Spacer()
            
            Button("Delete") {
                deleteReflection()
            }
            .foregroundColor(.red)
            .padding()
        }
        .navigationTitle("Reflection Detail")
    }
    
    func deleteReflection() {
        if let index = reflections.firstIndex(where: { $0.id == reflection.id }) {
            reflections.remove(at: index)
            UserDefaultsManager.saveReflections(reflections)
            presentationMode.wrappedValue.dismiss() // Dismiss the current view to go back
        }
    }
}


// Data model to store reflection
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

// Helper class to manage saving and loading reflections from UserDefaults
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
