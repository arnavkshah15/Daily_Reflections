import SwiftUI
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
