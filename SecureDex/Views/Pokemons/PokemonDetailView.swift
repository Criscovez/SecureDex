//
//  PokemonDetailView.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 25-05-24.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    var pokemon: Pokemon //el model
    @StateObject var viewModel = PokemonDelatilViewModel()
    var body: some View {
        NavigationStack {
         VStack {
             KFImage.url(pokemon.imageUrl)
                    .placeholder({
                        Image("pokeball")
                        
                        
                    })
                    .resizable()
                
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)
                //.cornerRadius(30)
                    .padding([.leading, .trailing],10)
                    .opacity(0.8)
             Text(pokemon.name)
                 .font(.title)
                 .foregroundStyle(.gray)
                 .bold()
             
            
             
             VStack{
                 Spacer()
                 Text("Abilities")
                     .font(.title2)
                     .padding(.top, 10.0)
                     .foregroundStyle(.gray)
                     .bold()
                 
                 List{
                     ForEach(viewModel.abilities, id: \.ability){data in
                         
                         Text(data.ability.name)
                             .font(.title3)
                             .multilineTextAlignment(.center)
                             .padding(0.0)
                             .foregroundStyle(.gray)
                             .bold()
                         
                         
                     }
                     .padding(.vertical)
                     
                 }
             }
             
            }
        }
        .onAppear{
            Task {
                await self.viewModel.getAbilities(IDPokemon: String(pokemon.id ?? 0))
            }
        }
    }
}

#Preview {
 PokemonDetailView(pokemon: Pokemon(name: "Monstruo", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
