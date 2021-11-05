//
//  ViewController.swift
//  pokedex-tools
// Test
//

import UIKit

enum Error: Swift.Error {
    case fileNotFound(name: String)
}

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
    
    @IBAction func readPokemonFromCSV(_ sender: UIBarButtonItem) {
            // fails if there is a comma in the data, but thankfully there are none in ours.
            // Source: https://medium.com/@deadbeef404/reading-a-csv-in-swift-7be7a20220c6
            
            do {
                guard let url = Bundle.main.url(
                    forResource: "pokemon",
                    withExtension: "csv"
                ) else {
                    throw Error.fileNotFound(name: "pokemon.csv")
                }
                let content = try String(contentsOf: url)
                let parsedCSV: [[String]] = content.components(
                    separatedBy: "\n"
                ).map{ $0.components(separatedBy: ",") }
                
                for row in parsedCSV[1...] {
                    
                    // Do not execute if row is empty
                    if !(row == [""]) {
                        var rowType: [String?] = row[3].components(separatedBy: "~")
                        var newType: PokemonType
                        
                        // If there is only one type for the Pokemon, its second type is nil
                        if rowType.count == 1 {
                            rowType.append(nil)
                        }
                        
                        if let rowType1 = rowType[0] {
                            if let rowType2 = rowType[1] {
                                newType = PokemonType(type1: Type(rawValue: rowType1)!,
                                                          type2: Type(rawValue: rowType2)!)
                            } else {
                                newType = PokemonType(type1: Type(rawValue: rowType1)!, type2: nil)
                            }
                        } else {
                            print("An error occurred when setting the Pokemon's type.")
                            newType = PokemonType(type1: Type(rawValue: "Normal")!, type2: nil)
                        }
                        
                        let newPokemon = Pokemon(name: row[0],
                                                 generation: Int(row[13])!,
                                                 pokedexNumber: Int(row[1])!,
                                                 type: newType)
                        
                        pokemonStore.allPokemon.append(newPokemon)
                        
                        if let index = pokemonStore.allPokemon.firstIndex(of: newPokemon) {
                            let indexPath = IndexPath(row: index, section: 0)
                            
                            tableView.insertRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            } catch {
                print("Error reading Pokemon from CSV: \(error)")
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
        
        var temp = pokemon.type.type1.rawValue
        if let value = pokemon.type.type2?.rawValue {
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
            
            // Creates an Alert controller
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete \(pokemon.name)", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Delete", style: .default) { _ in
                print("Deleting")
                // TODO: delete from pokemon store
                
                // Remove the Pokemon from the store
                self.pokemonStore.removePokemon(pokemon)
                
                // Also remove that row from the table view with an animation
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alertController.addAction(delete)
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
                print("Canceling")
            }
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
            
            
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
                detailedPokemonViewController.pokemonStore = pokemonStore
                detailedPokemonViewController.pokemon = pokemon
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

