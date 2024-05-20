//
//  PokemonsView.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 18-05-24.
//

import SwiftUI

struct PokemonsView: View {
@StateObject var viewModel = PokemonsViewModel()

//@State private var filter: String = ""

var body: some View {
    NavigationStack{
        VStack {
            Text("Secure-Pokedex")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
                .bold()
                .id(1)
            List{
                ForEach(viewModel.pokemons){data in
                    
                    PokemonsRowView(pokemon: data).id(0)
                    
                    
                }
                .padding(.vertical)
            }}
    }
    .onAppear{
        //self.viewModel.getHeros(filter: "")
        Task {
         await   self.viewModel.getHeros()
        }
    }
//        .searchable(text: $filter,prompt: Text("buscar por nombre"))
//        .onChange(of: filter) { _, newValue in
//            //Llamar al viewModel.
//            //self.viewModel.getHeros(filter: newValue)
//            Task {
//
//
//               await self.viewModel.getHeros()
//            }
//        }
}
}

#Preview {
    PokemonsView()
}
