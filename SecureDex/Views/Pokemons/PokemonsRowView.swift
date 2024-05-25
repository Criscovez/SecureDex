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

            
            HStack{

                KFImage.url(pokemon.imageUrl)
                    .placeholder({
                        Image("pokeball")
                        
                      
                    })
                    .resizable()
                
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    //.cornerRadius(30)
                    .padding([.leading, .trailing],10)
                    .opacity(0.8)
                    
              
                    Text(pokemon.name)
                    .font(.title2)
                        .foregroundStyle(.gray)
                        .bold()
                        
              
        }
            
    }
    
}


#Preview {
    PokemonsRowView(pokemon: Pokemon(name: "Monstruo", url: "https://pokeapi.co/api/v2/pokemon/1/"))

}
