import SwiftUI

struct SavedReflectionsView: View {
    @Binding var reflections: [Reflection]
    
    var body: some View {
        List(reflections) { reflection in
            NavigationLink(destination: ReflectionDetailView(reflections: $reflections, reflection: reflection)) {
                HStack {
                   
                    VStack(alignment: .leading) {
                        
                        Text("\(reflection.heading)")
                            .font(.title)
                    }
                    
                    Spacer() 
                    
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
                .padding(10) 
            }
        }
        .navigationTitle("Saved Reflections")
    }
    
   
    func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func formattedTime(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}
