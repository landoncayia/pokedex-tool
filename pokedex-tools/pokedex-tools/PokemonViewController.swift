//
//  ViewController.swift
//  pokedex-tools
// Test
//

import UIKit

class PokemonViewController: UITableViewController {

    var pokemonStore: PokemonStore!
    
    @IBAction func addNewPokemon(_ sender: UIButton) {
        // Create a new, custom Pokemon and add it to the store
        let newPokemon = pokemonStore.createPokemon()
        
        // Figure out where that Pokemon is in the array
        if let index = pokemonStore.allPokemon.firstIndex(of: newPokemon) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If you are currently in editing mode...
        if isEditing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonStore.allPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Had to add this to prevent error
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // Set the text on the cell with the description of the Pokemon that is at the nth index of Pokemon, where n = row this cell will appear in on the table view
        let pokemon = pokemonStore.allPokemon[indexPath.row]
        
        cell.textLabel?.text = pokemon.name
        cell.detailTextLabel?.text = "Gen: \(String(pokemon.generation)) Dex: \(String(pokemon.pokedexNumber)) Type: \(pokemon.type.0.toString())"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let pokemon = pokemonStore.allPokemon[indexPath.row]
            
            // Remove the Pokemon from the store
            pokemonStore.removePokemon(pokemon)
            
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        // Update the model
        pokemonStore.movePokemon(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

