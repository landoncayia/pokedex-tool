//
//  PokemonStore.swift
//  pokedex-tools
//
//  Created by Landon Cayia on 10/26/21.
//

import UIKit

public class PokemonStore {
    
    var allPokemon = [Pokemon]()
    let pokemonArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("pokemon.plist")
    }()
    
    init() {
        do {
            let data = try Data(contentsOf: pokemonArchiveURL)
            let unarchiver = PropertyListDecoder()
            let pokemon = try unarchiver.decode([Pokemon].self, from: data)
            allPokemon = pokemon
        } catch {
            print("Error reading in saved items: \(error)")
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    @discardableResult func createPokemon() -> Pokemon {
        
        let newPokemon = Pokemon(random: false)
        
        allPokemon.append(newPokemon)
        
        allPokemon.sort(by: { $0.pokedexNumber < $1.pokedexNumber })
        
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
    
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(pokemonArchiveURL)")
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allPokemon)
            try data.write(to: pokemonArchiveURL, options: [.atomic])
            print("Saved all of the Pokemon")
            return true
        } catch let encodingError {
            print("Error encoding allPokemon: \(encodingError)")
            return false
        }
    }
}
