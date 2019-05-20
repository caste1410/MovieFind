//
//  Movie.swift
//  MovieFind
//
//  Created by Carlos Eduardo Castelán Vázquez on 3/29/19.
//  Copyright © 2019 Carlos Castelán Vázquez. All rights reserved.
//

import Foundation

public class Movie    {
    var id: Int
    var title: String
    var year : Int
    var imageName :     String
    
    init(_ unId: Int, _ unTitulo: String, _ unAño: Int, _ unNombre: String){
        id = unId
        title = unTitulo
        year = unAño
        imageName = unNombre
    }
}
