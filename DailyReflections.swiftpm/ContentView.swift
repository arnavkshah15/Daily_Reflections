import SwiftUI
import CoreML
struct ContentView: View {
    @State private var reflections: [Reflection] = UserDefaultsManager.loadReflections()
    @State private var questions = ["What was one challenging situation or problem you encountered today?",
                                    "Could you overcome the challenge? If yes, how did you manage it? If no, what do you think might be the reason?",
                                    "What was the most valuable advice or opinion someone shared with you today?"]
    @State private var answers = Array(repeating: "", count: 3)
    @State private var selectedRatings = [""]
    @State private var isSaved = true
   

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
                HStack{
                    Text("Daily Reflections")
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                }
                ScrollView {
                    Section() {
                        HStack{
                            Text("How was your day?")
                                .font(.headline).foregroundColor(.black)
                            Spacer()
                        }

                        Picker("Rating", selection: $selectedRatings[0]) {
                            Text("😞").tag("😞").font(.title)
                            Text("😐").tag("😐")
                            Text("🙂").tag("🙂")
                            Text("😊").tag("😊")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color(UIColor.systemGray4))
                        .cornerRadius(10)
                        .padding()

                        ForEach(0..<3, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(questions[index])
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)

                                MultilineTextView(text: $answers[index], placeholder: "")
                                    .frame(height: 100)
                                    .background(Color(UIColor.systemGray2))
                                    .cornerRadius(10.0)
                                    
                            }
                        }
                    }
                }

                Button("Submit") {
                    saveReflection()
                }
                .padding()
                .foregroundColor(.white)
                .background(allQuestionsAnswered && !selectedRatings[0].isEmpty ? Color.green : Color.gray)
                .cornerRadius(25.0)
                .padding(1)
                .disabled(!(allQuestionsAnswered && !selectedRatings[0].isEmpty))

                if isSaved {
                    NavigationLink(destination: SavedReflectionsView(reflections: $reflections)) { // Pass sentiment raw value to the destination view
                        Text("View Saved Reflections")
                            .foregroundColor(.green)
                            .padding()
                            .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
                            .cornerRadius(25.0)
                    }

                }

            }.padding(10)



            .background(Color(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)))
        }.background(Color.white)
    }

    func saveReflection() {
        var reflection = Reflection(date: Date(), heading: selectedRatings[0], answers: answers)
        reflections.append(reflection)
        selectedRatings = [""]
        answers = Array(repeating: "", count: 3)
        isSaved = true

        UserDefaultsManager.saveReflections(reflections)

        // Perform sentiment analysis on answers
        do {
            // Instantiate the Qualities model
            let qualitiesModel = Qualities()

            // Prepare the input text for the model
            let inputText = answers[1] // Assuming you want to analyze the second answer
            let qualitiesInput = QualitiesInput(text: inputText)

            // Make predictions using the Qualities model
            let prediction = try qualitiesModel.prediction(input: qualitiesInput)

            // Retrieve the predicted label
            let predictedLabel = prediction.label

            // Save the predicted label or relevant information into your Reflection object
            reflection.predictedLabel = predictedLabel // Assuming your Reflection object has a property for storing the predicted label

            // Update the reflections array with the updated reflection
            if let index = reflections.firstIndex(where: { $0.date == reflection.date }) {
                reflections[index] = reflection
            }

            // Save the reflections array
            UserDefaultsManager.saveReflections(reflections)
        } catch {
            print("Error performing sentiment analysis: \(error)")
        }
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
        textView.backgroundColor = UIColor.systemGray4
        textView.textColor = UIColor.white
        textView.tintColor = UIColor.black
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isEmpty {
            uiView.text = placeholder
            uiView.textColor = UIColor.white
        } else {
            uiView.text = text
            uiView.textColor = UIColor.black
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
