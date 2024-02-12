import SwiftUI

struct SavedReflectionsView: View {
    @Binding var reflections: [Reflection]
    
    var body: some View {
        List(reflections) { reflection in
            NavigationLink(destination: ReflectionDetailView(reflections: $reflections, reflection: reflection)) {
                HStack {
                    // Display heading
                    VStack(alignment: .leading) {
                        
                        Text("\(reflection.heading)")
                            .font(.title)
                    }
                    
                    Spacer() // Add spacing between heading and date-time
                    
                    // Display date
                    VStack(alignment: .leading) {
                        Text("Date")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(formattedDate(for: reflection.date))")
                            .font(.headline)
                    }
                    
                    Spacer() // Add spacing between date and time
                    
                    // Display time
                    VStack(alignment: .leading) {
                        Text("Time")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(formattedTime(for: reflection.date))")
                            .font(.headline)
                    }
                }
                .padding(10) // Add padding around the content
            }
        }
        .navigationTitle("Saved Reflections")
    }
    
    // Function to format date
    func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    // Function to format time
    func formattedTime(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}
