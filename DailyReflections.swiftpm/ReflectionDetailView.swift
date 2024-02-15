import SwiftUI

struct ReflectionDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var reflections: [Reflection]
    var reflection: Reflection
    let questions = ["What was one challenging situation or problem you encountered today?",
                     "Could you overcome the challenge? If yes, how did you manage it? If no, what do you think might be the reason?",
                     "What was the most valuable advice or opinion someone shared with you today?"]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            if let predictedLabel = reflection.predictedLabel {
                            Text("Predicted Label: \(predictedLabel)")
                                .padding()
                        }
            ForEach(0..<reflection.answers.count, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text(questions[index]) // Display the question from the array
                        .font(.title3)
                        .bold() // Make the question bold
                        .padding()
                    
                    Text(reflection.answers[index])
                        .padding(.horizontal).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).font(.headline)
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
