//
//  CurrentVirus.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 20.03.21.
//

import Foundation

final class CurrentVirus {
    
    static let shared = CurrentVirus()
    
    var virus: Virus?
}
