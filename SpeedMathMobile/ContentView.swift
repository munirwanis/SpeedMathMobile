//
//  ContentView.swift
//  SpeedMathMobile
//
//  Created by Munir Wanis on 2020-03-30.
//  Copyright © 2020 Munir Wanis. All rights reserved.
//

import SwiftUI

struct QuestionRow: View {
    var question: Question
    var position: Position
    
    var positionColor: Color {
        if position == .answered {
            if question.actualAnswer == question.userAnswer {
                return Color.green.opacity(0.8)
            } else {
                return Color.red.opacity(0.8)
            }
        } else if position == .upcoming {
            return Color.black.opacity(0.5)
        } else {
            return .blue
        }
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                if question.paddingAmount > 0 {
                    Text(String(repeating: " ", count: question.paddingAmount))
                }
                
                Text(question.text)
            }
            .padding([.top, .bottom, .leading])
                
            ZStack {
                Text(" ")
                    .padding()
                    .frame(width: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(positionColor)
                )
                
                TypingView(text: question.userAnswer)
            }
        }
        .font(.system(size: 24, weight: .regular, design: .monospaced))
        .foregroundColor(.white)
    }
}

struct ContentView: View {
    @State private var questions = [Question]()
    @State private var number = 0
    @State private var isPresenting = false
    
    var score: Int {
        var total = 0
        
        for i in 0..<number {
            if questions[i].userAnswer == questions[i].actualAnswer {
                total += 1
            }
        }
        
        return total
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<questions.count, id: \.self) { index in
                QuestionRow(question: self.questions[index], position: self.position(for: index))
                    .offset(x: 0, y: CGFloat(index) * 100 - CGFloat(self.number) * 100)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Text("Score: \(score)")
                        .padding()
                        .background(Capsule().fill(Color.white.opacity(0.8)))
                        .animation(nil)
                }
                
                Spacer()
            }
            .font(.largeTitle)
            .foregroundColor(.black)
            .padding()
            .padding(.top, 30)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.blue, .black]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea([.bottom, .top])
            .onAppear(perform: createQuestions)
            .alert(isPresented: $isPresenting) {
                Alert(title: Text("The End!"), message: Text("You finished with score: \(score)"), dismissButton: .default(Text("Start Over"), action: {
                    withAnimation {
                        self.number = 0
                    }
                    self.questions.removeAll()
                    self.createQuestions()
                }))
        }
        .onReceive(NotificationCenter.default.publisher(for: .enterNumber)) { note in
            guard let number = note.object as? Int else { return }
            
            if self.questions[self.number].userAnswer.count < 3 {
                self.questions[self.number].userAnswer += String(number)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .removeNumber)) { _ in
            _ = self.questions[self.number].userAnswer.popLast()
        }
        .onReceive(NotificationCenter.default.publisher(for: .submitAnswer)) { _ in
            if self.questions[self.number].userAnswer.isEmpty == false {
                withAnimation {
                    self.number += 1
                }
                
                if self.number == self.questions.count {
                    self.isPresenting = true
                }
            }
        }
    }
    
    func createQuestions() {
        for _ in 1...10 {
            questions.append(Question())
        }
    }
    
    func position(for index: Int) -> Position {
        if index < number {
            return .answered
        } else if index == number {
            return .current
        } else {
            return .upcoming
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
