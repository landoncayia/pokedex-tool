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
    
    func removePokemon(_ pokemon: Pokemon) {
        if let index = allPokemon.firstIndex(of: pokemon) {
            allPokemon.remove(at: index)
        }
    }
    
    func movePokemon(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can reinsert it
        let movedPokemon = allPokemon[fromIndex]
        
        // Remove Pokemon from array
        allPokemon.remove(at: fromIndex)
        
        // Insert Pokemon in array at new location
        allPokemon.insert(movedPokemon, at: toIndex)
    }
}
