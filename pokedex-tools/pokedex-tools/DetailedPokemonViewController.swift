//
//  DetailedPokemonViewController.swift
//  pokedex-tools
//
//  Created by user203780 on 10/25/21.
//

import UIKit

class DetailedPokemonViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var genField: UITextField!
    @IBOutlet var dexNumField: UITextField!
    @IBOutlet var typeField: UITextField!
    @IBOutlet var evolutionField: UITextField!
    
    var pokemon: Pokemon!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
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
        
        var temp = pokemon.type.0.toString()
        if let value = pokemon.type.1?.toString() {
            temp+="| \(value)"
        }
        
        typeField.text = temp
        
        // TODO: Add evolutions here when you figure out how to implement it.
        // TODO: Image guide is in Chapter 15
    }
}
