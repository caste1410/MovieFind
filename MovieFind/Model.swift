//
//  Model.swift
//  MovieFind
//
//  Created by Carlos Eduardo Castelán Vázquez on 3/29/19.
//  Copyright © 2019 Carlos Castelán Vázquez. All rights reserved.
//

import SQLite3
import UIKit

public class Model{
    
    static var dbPointer: OpaquePointer? = nil
    static var statementpointer: OpaquePointer? = nil
    static var dbURL: URL? = nil
    static var quoteList = Array<Quote>()
    static var movieList = Array<Movie>()
    
    public static func createdb(_ aName: String){
        Model.dbURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(aName + ".sqlite")
        print("DB created at:")
        print(Model.dbURL!)
    }//end createDB
    
    public static func openDB(){
        if sqlite3_open(Model.dbURL!.path, &Model.dbPointer) != SQLITE_OK
        {
            print("Error opening database.")
        }//end if
        else{
            print("DB open.")
        }//end else
    }//end openDB
    
    public static func execute(_ aQuery: String){
        var errorMessage: String
        
        if sqlite3_exec(Model.dbPointer, aQuery, nil,nil,nil) != SQLITE_OK{
            errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error executing SQL statement \(errorMessage)")
            
        } else
        {
            print("SQL statement executed: ")
            print(aQuery)
        }
    }//end exec
    
    
    private static func queryIsPrepared(query: String) -> Bool{
        var queryIsPrepared: Bool
        var errorMessage: String
        //
        queryIsPrepared = false
        if sqlite3_prepare(dbPointer, query, -1, &statementpointer, nil) != SQLITE_OK{
            errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
            print("Error preparing query: " + query)
            print(errorMessage)
        }//end if
        else{
            queryIsPrepared = true
        }//end else
        return queryIsPrepared
    }
    
    static func getResultSetQuote() -> Array<Quote>{
        var resultSet :Array<Quote>
        var id: Int32
        var quote : String
        var movieId: Int32
        
        resultSet = []
        
        while(sqlite3_step(statementpointer) == SQLITE_ROW){
            id = sqlite3_column_int(statementpointer, 0)
            quote = String(cString: sqlite3_column_text(statementpointer, 1))
            movieId = sqlite3_column_int(statementpointer, 2)
            
            resultSet.append(Quote(Int(id), quote, Int(movieId)))
        }//end while
        return resultSet
    }
    
    static func getResultSetMovie() -> Array<Movie>{
        var resultSet :Array<Movie>
        var id: Int32
        var title : String
        var year: Int32
        var imageName : String
        
        resultSet = []
        
        while(sqlite3_step(statementpointer) == SQLITE_ROW){
            id = sqlite3_column_int(statementpointer, 0)
            title = String(cString: sqlite3_column_text(statementpointer, 1))
            year = sqlite3_column_int(statementpointer, 2)
            imageName = String(cString: sqlite3_column_text(statementpointer, 3))
            
            resultSet.append(Movie(Int(id), title, Int(year), imageName))
        }//end while
        return resultSet
    }
    
    public static func insertIntoQuotes(quote: String, movieId: String){
        let insertQuery = "INSERT INTO Quotes(quote, movieId) VALUES (?,?)"
        var errorMessage: String
        
        if queryIsPrepared(query: insertQuery){
            //binding parameters
            if sqlite3_bind_text(statementpointer, 1, (quote as NSString).utf8String, -1, nil) != SQLITE_OK{
                errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
                print("Failure binding quote: \(errorMessage)")
                return
            }//end if
            else{
                print("Binding quote value ... OK.")
            }//end else
            
            if sqlite3_bind_int(statementpointer, 2, (movieId as NSString).intValue) != SQLITE_OK{
                errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
                print("Failure binding movieId: \(errorMessage)")
                return
            }//end if
            else{
                print("Binding movieId .... OK.")
            }//end else
            
            if sqlite3_step(statementpointer) != SQLITE_DONE{
                errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
                print("Failure inserting record: \(errorMessage)")
                return
            }//end if
            else{
                print("Record inserted.")
            }//end else
        }//end if
    }
    
    public static func insertIntoMovies(title: String, year: String, imageName: String){
        let insertQuery = "INSERT INTO Movies(title, year, imageName) VALUES (?,?,?)"
        var errorMessage: String
        print(title)
        if queryIsPrepared(query: insertQuery){
            //binding parameters
            if sqlite3_bind_text(statementpointer, 1, (title as NSString).utf8String, -1, nil) != SQLITE_OK{
                errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
                print("Failure binding title: \(errorMessage)")
                return
            }//end if
            else{
                print("Binding title ... OK.")
            }//end else
            
            if sqlite3_bind_int(statementpointer, 2, (year as NSString).intValue) != SQLITE_OK{
                errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
                print("Failure binding year: \(errorMessage)")
                return
            }//end if
            else{
                print("Binding year .... OK.")
            }//end else
            
            if sqlite3_bind_text(statementpointer, 3, (imageName as NSString).utf8String, -1, nil) != SQLITE_OK{
                errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
                print("Failure binding imageName: \(errorMessage)")
                return
            }//end if
            else{
                print("Binding imageName ... OK.")
            }//end else
            
            if sqlite3_step(statementpointer) != SQLITE_DONE{
                errorMessage = String(cString: sqlite3_errmsg(Model.dbPointer)!)
                print("Failure inserting record: \(errorMessage)")
                return
            }//end if
            else{
                print("Record inserted.")
            }//end else
        }//end if
    }
    
    public static func selectQuote(quote: String){
        let selectQuote = "Select * FROM Quotes WHERE quote LIKE '%\(quote)%'"
        if queryIsPrepared(query: selectQuote)
        {
            quoteList = getResultSetQuote()
        }
    }
    
    public static func selectAllQuotes(){
        let selectAllQuotes = "Select * FROM Quotes "
        if queryIsPrepared(query: selectAllQuotes)
        {
            quoteList = getResultSetQuote()
        }
    }
    
    public static func selectAllMovies(){
        let selectAllMovies = "Select * FROM Movies"
        if queryIsPrepared(query: selectAllMovies)
        {
            movieList = getResultSetMovie()
        }
    }
    
    public static func selectMovie(id: String){
        let selectMovie = "Select * FROM Movies WHERE id = '\(id)'"
        
        if queryIsPrepared(query: selectMovie)
        {
            movieList = getResultSetMovie()
        }
    }
    
}

