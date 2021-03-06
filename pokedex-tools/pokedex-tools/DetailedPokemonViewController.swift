//
//  DetailedPokemonViewController.swift
//  pokedex-tools
//
//  Created by user203780 on 10/25/21.
//

import UIKit

class DetailedPokemonViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var genField: UITextField!
    @IBOutlet var dexNumField: UITextField!
    @IBOutlet var type1Field: UITextField!
    @IBOutlet var type2Field: UITextField!
    
    @IBAction func deleteAlertAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete \(nameField.text!)", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .default) { _ in
            print("Deleting")
            
            // TODO: delete from pokemon store
            self.pokemonStore.removePokemon(self.pokemon)
            
            self.navigationController!.popViewController(animated: true)
        }
        alertController.addAction(delete)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            print("Canceling")
        }
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    var pokemon: Pokemon! {
        didSet {
            navigationItem.title = pokemon.name
        }
    }
    
    var pokemonStore: PokemonStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        nameField.text = pokemon.name
        genField.text = numberFormatter.string(from: NSNumber(value: pokemon.generation))
        dexNumField.text = numberFormatter.string(from: NSNumber(value: pokemon.pokedexNumber))
        
        
        type1Field.text = pokemon.type.type1.rawValue
        if let value = pokemon.type.type2?.rawValue {
            type2Field.text = value
        } else {
            type2Field.text = ""
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to pokemon
        if let nameFieldText = nameField.text {
            if nameFieldText != "" {
                pokemon.name = nameFieldText
            } else {
                pokemon.name = "Name"
            }
        }
        if let valueText = genField.text,
           let value = numberFormatter.number(from: valueText) {
            pokemon.generation = value.intValue
        } else {
            pokemon.generation = 0
        }
        if let valueText = dexNumField.text,
           let value = numberFormatter.number(from: valueText) {
            pokemon.pokedexNumber = value.intValue
        } else {
            pokemon.pokedexNumber = 0
        }
        
        let type1Text = type1Field.text ?? ""
        let type2Text = type2Field.text ?? ""
        
        if let type1 = Type(rawValue: type1Text) {
            if let type2 = Type(rawValue: type2Text) {
                // Both types are present and valid; assign both
                pokemon.type = PokemonType(type1: type1, type2: type2)
            } else {
                // Only the first type is present and valid; assign first, second is nil
                pokemon.type = PokemonType(type1: type1, type2: nil)
            }
        } else {
            // Neither type is present and valid; print message and set type1 to Normal
            print("First type is invalid; Pokemon must have at least one type. Setting to Normal.")
            pokemon.type = PokemonType(type1: Type.Normal, type2: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
