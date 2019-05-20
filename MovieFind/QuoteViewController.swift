//
//  QuoteViewController.swift
//  MovieFind
//
//  Created by Carlos Eduardo Castelán Vázquez on 3/29/19.
//  Copyright © 2019 Carlos Castelán Vázquez. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleAndYear: UILabel!
    @IBOutlet weak var quoteText: UITextView!
    
    
    @IBAction func shareQuote(_ sender: Any) {
        let quote = "\(quoteText.text!)\n\(movieTitleAndYear.text!)"
        let activityController = UIActivityViewController(activityItems: [quote],
                                                          applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        print(Model.movieList.first!.imageName)
        let imageName = UIImage(named: Model.movieList.first!.imageName)
        movieImage.image = imageName
        movieTitleAndYear.text = Model.movieList.first!.title + " (\(Model.movieList.first!.year))"
        quoteText.text = Model.quoteList.first!.quote
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}

