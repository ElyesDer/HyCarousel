//
//  ContentView.swift
//  Shared
//
//  Created by ElyesDer on 20/2/2021.
//

import SwiftUI

class Model : Identifiable {
    let id = UUID()
    let name = "Random \(UUID())"
    var number : Int
    
    init(number : Int) {
        self.number = number
    }
}

class ViewModel: ObservableObject {
    @Published var content : [Model] = [
        Model(number : 1),
        Model(number : 2),
        Model(number : 3),
        Model(number : 4),
        Model(number : 5),
        Model(number : 6),
        Model(number : 7),
        Model(number : 8),
    ]
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        HyCarousel(viewModel.content, id: \.id) { index in
            Image( String(index.number))
                .resizable()
//                .padding()
                .frame(width: 150, height: 200, alignment: .center)
                .background(Color.blue)
                .modifier(Reflection(color: .white))
                .onTapGesture {
                    print(index.name)
                }
        }
        .environmentObject(Configurator(bgColor: .white, viewSize: .init(width: 150, height: 200), rotatedAngle: .degrees(50)))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
