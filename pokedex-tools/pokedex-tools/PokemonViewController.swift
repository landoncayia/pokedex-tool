//
//  ViewController.swift
//  pokedex-tools
// Test
//

import UIKit

class PokemonViewController: UITableViewController {

    var pokemonStore: PokemonStore!
    
    @IBAction func addNewPokemon(_ sender: UIBarButtonItem) {
        // Create a new, custom Pokemon and add it to the store
        let newPokemon = pokemonStore.createPokemon()
        
        // Figure out where that Pokemon is in the array
        if let index = pokemonStore.allPokemon.firstIndex(of: newPokemon) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonStore.allPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        
        // Set the text on the cell with the description of the Pokemon that is at the nth index of Pokemon, where n = row this cell will appear in on the table view
        let pokemon = pokemonStore.allPokemon[indexPath.row]
       
        cell.nameLabel.text = pokemon.name
        cell.genDexLabel.text = "#\(pokemon.pokedexNumber) | Gen: \(pokemon.generation)"
        
        var temp = pokemon.type.0.rawValue
        if let value = pokemon.type.1?.rawValue {
            temp+=" | \(value)"
        }
        
        cell.typeLabel.text = temp
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segye is the "showPokemon" segue
        switch segue.identifier {
        case "showPokemon":
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the Pokemon associated with this row and pass it along
                let pokemon = pokemonStore.allPokemon[row]
                let detailedPokemonViewController = segue.destination as! DetailedPokemonViewController
                detailedPokemonViewController.pokemon = pokemon
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

