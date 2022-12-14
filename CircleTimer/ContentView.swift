//
//  ContentView.swift
//  CircleTimer
//
//  Created by Neal Archival on 12/13/22.
//

import SwiftUI
import Combine

struct ContentView: View {
    private let originalTime: Int = 10
    @State private var remainingSeconds: Int = 10
    @State private var isRunning: Bool = false
    @State private var circleTrim: CGFloat = 1.0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: 300, height: 300)
                .foregroundColor(.white)
                .overlay(alignment: .center) {
                    ZStack {
                        Circle()
                            .trim(from: 0.0, to: circleTrim)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: 300, height: 300)
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(90))
                            .scaleEffect(y: -1)
                        Text("\(remainingSeconds)")
                            .font(.system(size: 64, weight: .bold))
                            .foregroundColor(Color.blue)
                    }
                } // Circle Overlay
                .onReceive(timer) { _ in
                    if self.isRunning {
                        if remainingSeconds == 1 {
                            self.isRunning = false
                        }
                        withAnimation(.easeInOut) {
                            self.remainingSeconds -= 1
                        }
                        withAnimation(.linear) {
                            self.circleTrim = CGFloat(Double(remainingSeconds) / Double(originalTime))
                            print(self.circleTrim)
                        }
                    }
                }
            
            controlButton(text: "Start", onClick: self.startTimer, disabled: isRunning)
            controlButton(text: "Pause", onClick: self.pauseTimer, disabled: !isRunning)
            controlButton(text: "Reset", onClick: self.resetTimer, disabled: false)
            
        } // VStack
    } // body
    
    
    func startTimer() {
        self.isRunning = true
    }
    
    func pauseTimer() {
        self.isRunning = false
    }
    
    func resetTimer() {
        withAnimation(.none) {
            self.remainingSeconds = self.originalTime
            self.circleTrim = 1.0
        }
    }
    
    
    @ViewBuilder
    func controlButton(text: String, onClick: @escaping () -> Void, disabled: Bool) -> some View {
            Button(action: {
                onClick()
            }) {
                Text("\(text)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 50)
                    .background(disabled ? Color.gray : Color.blue)
                    .cornerRadius(12)
            }
            .padding([.top], 20)
            .disabled(disabled)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
