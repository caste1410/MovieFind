//
//  Data.swift
//  MovieFind
//
//  Created by Carlos Eduardo Castelán Vázquez on 5/18/19.
//  Copyright © 2019 Carlos Castelán Vázquez. All rights reserved.
//

import UIKit

public class Dataset{
    public static func setDB(){
        Model.createdb("MovieFind")
        Model.openDB()
        Model.execute("DROP TABLE IF EXISTS Movies")
        Model.execute("DROP TABLE IF EXISTS Quotes")
        Model.execute("CREATE TABLE IF NOT EXISTS Movies (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, year INTEGER, imageName TEXT)")
        Model.execute("CREATE TABLE IF NOT EXISTS Quotes (id INTEGER PRIMARY KEY AUTOINCREMENT, quote TEXT, movieId INTEGER, FOREIGN KEY(movieId) REFERENCES Movies(id))")
    }
    public static func setMovies(){
            Model.insertIntoMovies(title: "Harry Potter y El Prisionero de Azkaban", year: "2004", imageName: "hp3")
            Model.insertIntoMovies(title: "Toy Story", year: "1995", imageName: "toystory")
            Model.insertIntoMovies(title: "Forrest Gump", year: "1994", imageName: "fg")
    }
    public static func setQuotes(){
        Model.insertIntoQuotes(quote: "Juro solemnemente que mis intenciones no son buenas.", movieId: "1")
        Model.insertIntoQuotes(quote: "No estoy volando estoy cayendo con estilo.", movieId: "2")
        Model.insertIntoQuotes(quote: "Tonto es el que hace tonterías.", movieId: "3")
        Model.insertIntoQuotes(quote: "Puede que yo no sea muy listo, pero si sé lo que es el amor.", movieId: "3")
        Model.insertIntoQuotes(quote: "Mamá dice que la vida es como una caja de bombones, nunca sabes el que te va a tocar.", movieId: "3")
        
    }
    
}
