//
//  ViewController.swift
//  pokedex-tools
//
//

import UIKit

class PokemonViewController: UITableViewController {

    var pokemonStore: PokemonStore!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonStore.allPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell with default appearance
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // Set the text on the cell with the description of the Pokemon that is at the nth index of Pokemon, where n = row this cell will appear in on the table view
        let pokemon = pokemonStore.allPokemon[indexPath.row]
        
        cell.textLabel?.text = pokemon.name
        cell.detailTextLabel?.text = "Gen: \(String(pokemon.generation)) Dex: \(String(pokemon.pokedexNumber)) Type: \(pokemon.type.0.toString())"
        
        return cell
    }

}

