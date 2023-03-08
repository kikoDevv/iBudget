//
//  ContentView.swift
//  iBudget
//
//  Created by Kiko on 2023-03-02.
//

import SwiftUI

struct ContentView: View {
    @State var dectionaryListan = UserDefaults.standard.object(forKey: "listan") as? [String:Int] ?? [String:Int]()
    @State var inkomst:Float = UserDefaults.standard.float(forKey: "inkomst")
    @State var mainView: Bool = false
    @State var mvEffect: Bool = false
    @State var avEffect: Bool = false
    @State var secondView: Bool = true
    @State var editView: Bool = false
    @State var addView: Bool = false
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
                        .scaleEffect(mvEffect ? 0 : 1)
                    Text(inkomst == 0 ? "välj din inkomst" : "\(Int(inkomst)) kr")
                        .scaleEffect(mvEffect ? 0 : 1)
                        .font(.largeTitle)
                        .padding(1)
                    Slider(value: $inkomst, in: 0...70000, step: 500)
                        .scaleEffect(mvEffect ? 0 : 1)
                        .padding(.trailing,30)
                        .padding(.leading,30)
                        .padding(.bottom,50)
                        .padding(.top,30)
                    Button("Starta"){
                        // start bt action
                        UserDefaults.standard.set(inkomst, forKey: "inkomst")
                            withAnimation(){
                            mvEffect = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                            mainView = false
                            secondView = true
                        }
                    }
                    .scaleEffect(mvEffect ? 0 : 1)
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
                                    Text("\(Int(inkomst)) kr")
                                    Spacer()
                                    let spar = Int(inkomst) - dectionaryListan.values.reduce(0,+)
                                    Text("\(spar) kr")
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
                                    let spend = dectionaryListan.values.reduce(0,+)
                                    Text("\(spend) kr")
                                    Spacer()
                                    let summan = Int(inkomst) - dectionaryListan.values.reduce(0,+)
                                    let årsSpar = summan * 12
                                    Text("\(årsSpar) kr")
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
                            .onDelete(perform: tabort)
                        }
                    }
                    .navigationBarItems(leading: Button("edit"){
                        // edit bt action
                            editView = true
                        withAnimation(){
                            avEffect = true
                        }
                    }, trailing: Button("add"){
                        // add bt action
                            addView = true
                        withAnimation(){
                            avEffect = true
                        }
                        
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
                                .offset(y: avEffect ? 0 : 450)
                            VStack{
                                TextField("skriv kostnad katagori", text: $inputKey)
                                    .padding()
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(10)
                                    .padding(40)
                                    .offset(y: avEffect ? 0 : 450)
                                TextField("ange kostnaden", text: $inputValue)
                                    .padding()
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(10)
                                    .padding(40)
                                    .keyboardType(.decimalPad)
                                    .offset(y: avEffect ? 0 : 450)
                                HStack{
                                    Button("aybryt    "){
                                        inputKey = ""
                                        inputValue = ""
                                        withAnimation(){
                                            addView = false
                                            avEffect = false
                                        }
                                    }
                                    .padding(10)
                                    .background(Color.red)
                                    .cornerRadius(20)
                                    .offset(y: avEffect ? 0 : 450)
                                    if inputKey.isEmpty == false && inputValue.isEmpty == false{
                                        Button("spara    "){
                                            dectionaryListan[inputKey]=Int(inputValue)
                                            UserDefaults.standard.set(dectionaryListan, forKey: "listan")
                                            inputKey = ""
                                            inputValue = ""
                                            withAnimation(){
                                                addView = false
                                                avEffect = false
                                            }
                                        }
                                        .padding(10)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .offset(y: avEffect ? 0 : 450)
                                    }
                                }
                            }
                        }
                    }
                }
                // ============== edite view with transition =========================
                if editView {
                    VStack {
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 35)
                                .foregroundColor(Color.blue)
                                .frame(height: 400)
                                .padding(20)
                                .offset(y: avEffect ? 0 : 450)
                            VStack{
                                Text("ändra din inkomst här")
                                    .padding()
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(10)
                                    .offset(y: avEffect ? 0 : 450)
                                Text("\(Int(inkomst)) kr")
                                    .padding()
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(10)
                                    .padding(40)
                                    .keyboardType(.decimalPad)
                                    .offset(y: avEffect ? 0 : 450)
                                Slider(value: $inkomst, in: 0...70000, step: 1000)
                                    .padding(50)
                                HStack{
                                        Button("spara    "){
                                            UserDefaults.standard.set(inkomst, forKey: "inkomst")
                                            withAnimation(){
                                                editView = false
                                                avEffect = false
                                            }
                                        }
                                        .padding(10)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .offset(y: avEffect ? 0 : 450)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func tabort(at offsets: IndexSet){
        if let ndx = offsets.first {
            let item = dectionaryListan.sorted{ $0.1 > $1.1 }[ndx]
            dectionaryListan.removeValue(forKey: item.key)
            //spar = Int(sliderInkomst) - listan.values.reduce(0,+)
            UserDefaults.standard.set(dectionaryListan, forKey: "listan")
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
