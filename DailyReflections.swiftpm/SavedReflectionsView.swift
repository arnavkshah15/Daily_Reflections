import SwiftUI

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
