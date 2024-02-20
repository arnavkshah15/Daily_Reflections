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
                Text("Strengths:").font(.title3)
                                .padding()
                if(predictedLabel=="3"){
                    Text("Resilience\nEmpathy\nSelf-awareness").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).font(.headline).padding()
                    Text("Weaknesses:").font(.title3)
                                    .padding()
                    Text("Emotional vulnerability\nDecreased motivation\nNegative self-perception").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).font(.headline).padding()
                }
                else if(predictedLabel=="0"){
                    Text("Compassion\nPerseverance\nAdaptability").foregroundColor(.blue).font(.headline).padding()
                               
                               Text("Weaknesses:").font(.title3)
                                   .padding()
                               Text("Increased sensitivity\nDifficulty trusting\nSelf-doubt").foregroundColor(.blue).font(.headline).padding()
                }
                else if(predictedLabel=="1"){
                    Text("Optimism\nResilience\nEnergy").foregroundColor(.blue).font(.headline).padding()
                                
                                Text("Weaknesses:").font(.title3)
                                    .padding()
                                Text("Overlooking risks\nIgnoring negative aspects\nTaking things for granted").foregroundColor(.blue).font(.headline).padding()
                }
                else if(predictedLabel=="4"){
                    Text("Alertness\nSurvival Instincts\nIncreased Awareness").foregroundColor(.blue).font(.headline).padding()
                               
                               Text("Weaknesses:").font(.title3)
                                   .padding()
                               Text("Paranoia\nOverreaction\nImpaired Judgment").foregroundColor(.blue).font(.headline).padding()
                }
                else if(predictedLabel=="5"){
                    Text("Assertiveness\nEnergy\nMotivation for Change").foregroundColor(.blue).font(.headline).padding()
                                
                                Text("Weaknesses:").font(.title3)
                                    .padding()
                                Text("Impulsiveness\nAggression\nDifficulty in Communication").foregroundColor(.blue).font(.headline).padding()
                }
                else{
                    Text("Kindness\nEmpathy\nAffectionate").foregroundColor(.blue).font(.headline).padding()
                                
                                Text("Weaknesses:").font(.title3)
                                    .padding()
                                Text("Overly trusting\nDifficulty saying no\nVulnerability to manipulation").foregroundColor(.blue).font(.headline).padding()
                }
                
                
                
                
                        }
            ForEach(0..<reflection.answers.count, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text(questions[index]) 
                        .font(.title3)
                        .bold() 
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
            presentationMode.wrappedValue.dismiss() 
        }
    }
}
