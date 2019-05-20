//
//  ViewController.swift
//  MovieFind
//
//  Created by Carlos Castelán Vázquez on 2/18/19.
//  Copyright © 2019 Carlos Castelán Vázquez. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "es-MX"))
    var task:SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var request: SFSpeechAudioBufferRecognitionRequest?
    let quote = ""
    var text: String?
    @IBOutlet weak var buttonTitle: UIButton!
    @IBOutlet weak var botonPrincipal: UIButton!
    @IBOutlet weak var texto: UILabel!
    
    @IBAction func findQuote(_ sender: Any) {
        if audioEngine.isRunning{
            audioEngine.stop()
            request?.endAudio()
            botonPrincipal.isEnabled = false
            botonPrincipal.setTitle("MF", for: .normal)
            enableButtonTittle()
        }
        else{
            record()
            botonPrincipal.setTitle("L", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      Modificamos la forma del botón pincipal
        botonPrincipal.layer.cornerRadius = botonPrincipal.frame.width/2
        botonPrincipal.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        botonPrincipal.layer.shadowOffset = CGSize(width: 1, height: 1)
        botonPrincipal.layer.shadowRadius = botonPrincipal.frame.width/10
        botonPrincipal.layer.shadowOpacity = 1
        //      desbilitamos el botón principal y ocultamos el botón del titulo
        botonPrincipal.isEnabled = false
        buttonTitle.isHidden = true
        //      se crea y agregan los datos de la base de datos
        Dataset.setDB()
        Dataset.setMovies()
        Dataset.setQuotes()
        
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus{
            case.authorized:OperationQueue.main.addOperation {
                self.botonPrincipal.isEnabled = true
            }
                break
            case.denied:print("User denied access")
                break
            case.restricted:print("User restricted access")
                break
            case.notDetermined:print("Speech recognition has not been authorized")
                break
            @unknown default:
                break
            }
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            botonPrincipal.isEnabled = true
        }else{
            botonPrincipal.isEnabled = false
        }
    }
    func record() {
        if task != nil{
            task?.cancel()
            task = nil
        }
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setMode(AVAudioSession.Mode.measurement)
            try session.setActive(true)
            
        }catch{
            print("Error: Setting audio session properties")
        }
        request = SFSpeechAudioBufferRecognitionRequest()
        guard request != nil else{
            fatalError("Cannot create an SFSPEECH")
        }
        request?.shouldReportPartialResults = true
        task = speechRecognizer?.recognitionTask(with: request!, resultHandler:
            {(result, error) in
                var isFinal = false
                if result != nil{
                    let text = result?.bestTranscription.formattedString
                    self.texto.text = text
                    isFinal = (result?.isFinal)!
                }
                if error != nil || isFinal{
                    self.audioEngine.stop()
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    self.request = nil
                    self.task = nil
                    self.botonPrincipal.isEnabled = true
                }
        })
        
        let format = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: format){
            (buffer, when) in
            self.request?.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            print("ERROR starting audio engine")
        }
        
    }
    func enableButtonTittle(){
        Model.selectQuote(quote: texto.text!)
        if Model.quoteList.first?.movieId != nil{
            let movieID = String(Model.quoteList.first!.movieId)
            print(movieID)
            Model.selectMovie(id: movieID)
            if let titulo = Model.movieList.first?.title{
                buttonTitle.setTitle(titulo, for: .normal)
                buttonTitle.isHidden = false
                buttonTitle.isUserInteractionEnabled = true
            }
            
        }else{
            buttonTitle.setTitle("Intenta de nuevo", for: .normal)
            buttonTitle.isHidden = false
            buttonTitle.isUserInteractionEnabled = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
