import SwiftUI

struct ContentView: View {
    @State private var apiResponse: ApiResponse?
    @State private var currentTopicIndex = 0
    @State private var showQuestion = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let topic = apiResponse?.topics[currentTopicIndex] {
                    if showQuestion {
                        QuestionView(question: topic.question) {
                            self.moveToNextTopic()
                        }
                    } else {
                        TopicView(topic: topic)
                        Button(action: {
                            self.showQuestion.toggle()
                        }) {
                            Text("Ir a la Pregunta")
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                    }
                } else {
                    Text("Cargando...")
                }
            }
            .navigationTitle("Tema \(currentTopicIndex + 1)")
        }
        .onAppear {
            APIManager.shared.fetchData { response in
                if let response = response {
                    self.apiResponse = response
                } else {
                    print("Error: No se pudo obtener la respuesta de la API")
                }
            }
        }
    }
    
    private func moveToNextTopic() {
        if currentTopicIndex < (apiResponse?.topics.count ?? 0) - 1 {
            currentTopicIndex += 1
        } else {
            // No hay más temas, puedes implementar alguna lógica aquí si es necesario
        }
        self.showQuestion = false
    }
}

struct TopicView: View {
    let topic: Topic
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Título del Tema: \(topic.title)")
                .padding()
            Text("Contenido del Tema: \(topic.content)")
                .padding()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
}

struct QuestionView: View {
    let question: Question
    let onNextTopic: () -> Void
    
    @State private var selectedOptions: Set<String> = []
    @State private var incorrectAttempts = 0
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pregunta del Tema: \(question.content)")
                .padding()
            
            ForEach(questionOptions(), id: \.self) { option in
                Button(action: {
                    toggleOption(option)
                }) {
                    Text(option)
                }
                .padding()
                .background(selectedOptions.contains(option) ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 5)
            }
            
            
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Pista"), message: Text(question.clue), dismissButton: .default(Text("OK")))
        }
        Button(action: {
            checkAnswers()
        }) {
            Text("Comprobar Respuesta")
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.top)
    }
    
    private func questionOptions() -> [String] {
        return (question.correct_options ?? []) + (question.incorrect_options ?? [])
    }
    
    private func toggleOption(_ option: String) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
    
    private func checkAnswers() {
        let correctOptionsSet = Set(question.correct_options ?? [])
        
        if selectedOptions == correctOptionsSet {
            // Respuesta correcta, avanza al siguiente tema
            onNextTopic()
        } else {
                        // Respuesta incorrecta
            incorrectAttempts += 1
            if incorrectAttempts >= 3 {
                // Muestra la pista en una alerta si se equivoca 3 veces
                showAlert = true
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







/*  Text("Question Content: \(topic.question.content)")
Text("Question Clue: \( topic.question.clue)")

if let incorrectOptions = topic.question.incorrect_options {
                            ForEach(incorrectOptions, id: \.self) { option in
                                Text("Incorrect Option: \(option)")
                            }
                        }
if let correctOptions = topic.question.correct_options {
                            ForEach(correctOptions, id: \.self) { option in
                                Text("Correct Option: \(option)")
                            }
                        }
 */
// Aquí puedes agregar más Text views para mostrar otros datos del tema si es necesario
