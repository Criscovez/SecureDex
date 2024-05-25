//
//  PokemonsRowView.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 18-05-24.
//

import SwiftUI
import Kingfisher

struct PokemonsRowView: View {
    var pokemon: Pokemon //el modelo
    
    var body: some View {

            
            VStack{

                KFImage.url(pokemon.imageUrl)
                    .placeholder({
                        Image("pokeball")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .padding([.leading, .trailing],20)
                            .opacity(0.6)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding([.leading, .trailing],20)
                    .opacity(0.8)
                    .id(0)
                
                Text(pokemon.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.gray)
                    .bold()
                    .id(1)
        }
    }
}

#Preview {
    PokemonsRowView(pokemon: Pokemon(name: "Monstruo", url: "https://pokeapi.co/api/v2/pokemon/1/"))

}
