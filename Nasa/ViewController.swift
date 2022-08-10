//
//  ViewController.swift
//  Nasa
//
//  Created by Alexandr Telbukh on 01.08.2022.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parsingJson()
    }
    func parsingJson(){
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=KLzYVc8lUwApUk965HJEAbcZlcHWoeY8pEYujfEb"
        let url = URL(string: urlString)
        guard url != nil else {
            print("URL error")
            return
        }
            
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                do {
                    let nasa = try decoder.decode(NasaApi.self, from: data!)
                    let imageURL = URL(string: nasa.url)
                    if let image = try? Data(contentsOf: imageURL!){
                    
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: image)
                            self.titleLable.text = nasa.title
                            self.dateLable.text = nasa.date
                            self.explanationLabel.text = nasa.explanation
                            self.copyrightLabel.text = nasa.copyright
                            
                        }
                    
                        
                    }
                } catch {
                    print("Error in JSON parsing")
                }
            }
        }
        dataTask.resume()
    }
}

