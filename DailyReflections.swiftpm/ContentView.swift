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
