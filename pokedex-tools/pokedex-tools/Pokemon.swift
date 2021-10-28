//
//  Pokemon.swift
//  pokedex-tools
//
//  Created by Landon Cayia on 10/26/21.
//

import UIKit

enum Type: String {
    case Normal, Fire, Water, Grass, Electric, Ice, Fighting, Poison, Ground, Flying, Psychic, Bug, Rock, Ghost, Dark, Dragon, Steel, Fairy
    
    func toString() -> String {
        return self.rawValue
    }
}

// Every Pokemon must have at least one type, but the second type is optional
typealias PokemonType = (Type, Type?)

class Pokemon: Equatable {
    var name: String
    var generation: Int
    var pokedexNumber: Int
    var type: PokemonType
    var evolutions: [Pokemon]?
    // Might get to this, might not
    //var photo: UIImage
    
    init(name: String, generation: Int, pokedexNumber: Int, type: PokemonType, evolutions: [Pokemon]?) {
        self.name = name
        self.generation = generation
        self.pokedexNumber = pokedexNumber
        self.type = type
        self.evolutions = evolutions
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Bulbasaur", "Charmander", "Squirtle"]
            let gens = [1, 2, 3]
            let dexNums = [1, 4, 7]
            let exTypes = [PokemonType(Type.Grass, nil), PokemonType(Type.Fire, nil), PokemonType(Type.Water, nil)]
            let evos = [[Pokemon(), Pokemon()], [Pokemon(), Pokemon()], [Pokemon(), Pokemon()]]
            
            let randomName = names.randomElement()!
            let randomGen = gens.randomElement()!
            let randomDexNum = dexNums.randomElement()!
            let randomType = exTypes.randomElement()!
            let randomEvo = evos.randomElement()!
            
            self.init(name: randomName,
                      generation: randomGen,
                      pokedexNumber: randomDexNum,
                      type: randomType,
                      evolutions: randomEvo)
        } else {
            self.init(name: "", generation: 0, pokedexNumber: 0, type: PokemonType(Type.Normal, nil), evolutions: nil)
        }
    }
    
    static func ==(lhs: Pokemon, rhs: Pokemon) -> Bool {
        // Two Pokemon are equal in the Pokedex if their names alone are equal
        return lhs.name == rhs.name
    }
}
