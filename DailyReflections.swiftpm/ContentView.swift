import SwiftUI

struct ContentView: View {
    @State private var reflections: [Reflection] = UserDefaultsManager.loadReflections()
    @State private var questions = ["What was one challenging situation or problem you encountered today?",
                                    "Could you overcome the challenge? If yes, how did you manage it? If no, what do you think might be the reason?",
                                    "What was the most valuable advice or opinion someone shared with you today?"]
    @State private var answers = Array(repeating: "", count: 3)
    @State private var selectedRatings = [""]
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
                    Section() {
                        Text("How was your day?")
                            .font(.headline).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                    
                        Picker("Rating", selection: $selectedRatings[0]) {
                            Text("😞").tag("😞").font(.title)
                            Text("😐").tag("😐")
                            Text("🙂").tag("🙂")
                            Text("😊").tag("😊")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        ForEach(0..<3, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Text(questions[index])
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(.vertical, 5)
                                
                                MultilineTextView(text: $answers[index], placeholder: "")
                                    .frame(height: 100)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8.0)
                            }
                        }
                    }
                }
                .padding(1)
                
                Button("Submit") {
                    saveReflection()
                }
                .padding()
                .foregroundColor(.white)
                .background(allQuestionsAnswered ? Color.blue : Color.gray)
                .cornerRadius(25.0)
                .padding(1)
                .disabled(!allQuestionsAnswered) // Disable the button if not all questions are answered
                
                if isSaved {
                    NavigationLink(destination: SavedReflectionsView(reflections: $reflections)) {
                        Text("View Saved Reflections")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(25.0)
                    }
                    .padding(1)
                }
                
            }
            .background(
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Daily Reflections")
        }
    }
    
    func saveReflection() {
        let reflection = Reflection(date: Date(), heading: selectedRatings[0], answers: answers)
        reflections.append(reflection)
        selectedRatings = [""]
        answers = Array(repeating: "", count: 3)
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

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.text = placeholder
        textView.backgroundColor = UIColor.systemGray6 // Set background color to gray
        textView.textColor = UIColor.lightGray
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isEmpty {
            uiView.text = placeholder
            uiView.textColor = UIColor.lightGray
        } else {
            uiView.text = text
            uiView.textColor = UIColor.label
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextView
        
        init(parent: MultilineTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
