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
    @IBOutlet var evolutionField: UITextField!
    
    var pokemon: Pokemon! {
        didSet {
            navigationItem.title = pokemon.name
        }
    }
    
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
        
       
        
        // TODO: Add evolutions here when you figure out how to implement it.
        // TODO: Image guide is in Chapter 15
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to pokemon
        pokemon.name = nameField.text ?? ""
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
        
        var type1 = type1Field.text ?? ""
        let type2 = type2Field.text ?? ""
        
        if type1 == "" {
            type1 = "Normal"
        }
        // TODO: Crashes if Type Field is empty
        if type2 != "" {
            pokemon.type = PokemonType(type1: Type(rawValue: type1)!, type2: Type(rawValue: type2))
        } else {
            pokemon.type = PokemonType(type1: Type(rawValue: type1)!, type2: nil)
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
