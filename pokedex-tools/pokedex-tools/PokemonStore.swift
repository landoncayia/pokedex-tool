//
//  PokemonStore.swift
//  pokedex-tools
//
//  Created by Landon Cayia on 10/26/21.
//

import UIKit

class PokemonStore {
    
    var allPokemon = [Pokemon]()
    
    @discardableResult func createPokemon() -> Pokemon {
        
        let newPokemon = Pokemon(random: true)
        
        allPokemon.append(newPokemon)
        
        return newPokemon
    }
    
    init() {
        for _ in 0..<5 {
            createPokemon()
        }
    }
    
}
