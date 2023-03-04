//
//  ContentView.swift
//  iBudget
//
//  Created by Kiko on 2023-03-02.
//

import SwiftUI

struct ContentView: View {
    @State var sliderInput:Float = 0
    @State var mainView: Bool = true
    @State var mvEffect: Bool = false
    @State var secondView: Bool = false
    @State var addView: Bool = false
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            Circle()
                .foregroundColor(Color.blue.opacity(0.4))
                .padding(-150)
            Circle()
                .foregroundColor(Color.blue.opacity(0.6))
                .padding(-90)
            Circle()
                .foregroundColor(Color.blue)
                .padding(-20)
                .shadow(radius: 10)
            Circle()
                .scale(mvEffect ? 3 : 0)
                .offset(y:100)
                .foregroundColor(Color.black)
            VStack{
                Text("Välkommen")
                Text(sliderInput == 0 ? "välj din inkomst" : "\(Int(sliderInput)) kr")
                    .font(.largeTitle)
                    .padding(1)
                Slider(value: $sliderInput, in: 0...70000, step: 500)
                    .padding(.trailing,30)
                    .padding(.leading,30)
                    .padding(.bottom,50)
                    .padding(.top,30)
                Button("Starta"){
                    // start bt action
                    withAnimation(){
                        mvEffect.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                        mainView = false
                        mainView = true
                    }
                }
                .padding(10)
                .foregroundColor(Color.white)
                .background(Color.black)
                .cornerRadius(20)
                .padding(.bottom,10)
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
