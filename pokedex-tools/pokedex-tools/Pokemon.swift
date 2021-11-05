//
//  Pokemon.swift
//  pokedex-tools
//
//  Created by Landon Cayia on 10/26/21.
//

import UIKit

enum Type: String, Codable {
case Normal = "Normal", Fire = "Fire", Water = "Water", Grass = "Grass", Electric = "Electric", Ice = "Ice", Fighting = "Fighting", Poison = "Poison", Ground = "Ground", Flying = "Flying", Psychic = "Psychic", Bug = "Bug", Rock = "Rock", Ghost = "Ghost", Dark = "Dark", Dragon = "Dragon", Steel = "Steel", Fairy = "Fairy"
}

// Every Pokemon must have at least one type, but the second type is optional
struct PokemonType: Codable {
    var type1: Type
    var type2: Optional<Type>
}

class Pokemon: Equatable, Codable {
    var name: String
    var generation: Int
    var pokedexNumber: Int
    var type: PokemonType
    //var photo: UIImage
    
    init(name: String, generation: Int, pokedexNumber: Int, type: PokemonType) {
        self.name = name
        self.generation = generation
        self.pokedexNumber = pokedexNumber
        self.type = type
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Bulbasaur", "Charmander", "Squirtle"]
            let gens = [1, 2, 3]
            let dexNums = [1, 4, 7]
            let exTypes = [PokemonType(type1: Type.Grass, type2: nil), PokemonType(type1: Type.Fire, type2: nil), PokemonType(type1: Type.Water, type2: nil)]
            
            let randomName = names.randomElement()!
            let randomGen = gens.randomElement()!
            let randomDexNum = dexNums.randomElement()!
            let randomType = exTypes.randomElement()!
            
            self.init(name: randomName,
                      generation: randomGen,
                      pokedexNumber: randomDexNum,
                      type: randomType)
        } else {
            self.init(name: "", generation: 0, pokedexNumber: 0, type: PokemonType(type1: Type.Normal, type2: nil))
        }
    }
    
    static func ==(lhs: Pokemon, rhs: Pokemon) -> Bool {
        // Two Pokemon are equal in the Pokedex if their names alone are equal
        return lhs.name == rhs.name
    }
}
