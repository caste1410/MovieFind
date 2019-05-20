//
//  Quote.swift
//  MovieFind
//
//  Created by Carlos Eduardo Castelán Vázquez on 3/29/19.
//  Copyright © 2019 Carlos Castelán Vázquez. All rights reserved.
//

import Foundation

public class Quote{
    var id: Int
    var quote: String
    var movieId: Int
    
    init(_ unId: Int, _ unQuote: String, _ unIdP: Int){
        id = unId
        quote = unQuote
        movieId = unIdP
        
    }
}
