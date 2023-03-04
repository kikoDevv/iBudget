//
//  ContentView.swift
//  iBudget
//
//  Created by Kiko on 2023-03-02.
//

import SwiftUI

struct ContentView: View {
    @State var dectionaryListan = UserDefaults.standard.object(forKey: "listan") as? [String:Int] ?? [String:Int]()
    @State var sliderInput:Float = 0
    @State var mainView: Bool = false
    @State var mvEffect: Bool = false
    @State var secondView: Bool = true
    @State var addView: Bool = true
    @State var inputKey = ""
    @State var inputValue = ""
    var body: some View {
        if mainView{
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
                            secondView = true
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
        if secondView{
            ZStack {
                NavigationView{
                    List{
                        Section(header: Text("budget")) {
                            VStack{
                                HStack{
                                    Text("inkomst")
                                    Spacer()
                                    Text("sparande")
                                }
                                HStack{
                                    Text("999 kr")
                                    Spacer()
                                    Text("999 kr")
                                }
                                ZStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(height: 10)
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 159,height: 10)
                                        .foregroundColor(Color.red)
                                }
                                HStack{
                                    Text("spend")
                                    Spacer()
                                    Text("års spar")
                                }
                                HStack{
                                    Text("999 kr")
                                    Spacer()
                                    Text("99 kr")
                                }
                            }
                        }
                    // section 2 spendering
                        Section(header: Text("kostnader")){
                            ForEach(dectionaryListan.sorted{$0.1 > $1.1}, id: \.key){ key, value in
                                HStack{
                                    Text(key)
                                    Spacer()
                                    Text("\(value) kr")
                                }
                            }
                        }
                    }
                    .navigationBarItems(leading: Button("edit"){
                        // edit bt action
                    }, trailing: Button("add"){
                        // add bt action
                        addView.toggle()
                    })
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("iBudget")
                }
                // ================ add view =========================
                if addView{
                    VStack {
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 35)
                                .foregroundColor(Color.blue)
                                .frame(height: 400)
                                .padding(20)
                            VStack{
                                TextField("skriv gatagorin", text: $inputKey)
                                    .padding()
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(10)
                                    .padding(40)
                                TextField("skriv kostnad", text: $inputValue)
                                    .padding()
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(10)
                                    .padding(40)
                                    .keyboardType(.decimalPad)
                                Button("spara    "){
                                    withAnimation(){
                                        addView = false
                                    }
                                    dectionaryListan[inputKey]=Int(inputValue)
                                    inputKey = ""
                                    inputValue = ""
                                }
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
