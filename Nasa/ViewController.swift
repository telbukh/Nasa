//
//  ViewController.swift
//  Nasa
//
//  Created by Alexandr Telbukh on 01.08.2022.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {


    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    private func showLoadingHUD() {
      let hud = MBProgressHUD.showAdded(to: contentView, animated: true)
      hud.label.text = "Loading..."
    }
    private func hideLoadingHUD() {
      MBProgressHUD.hide(for: contentView, animated: true)
    }
    
    func loadData() {
        showLoadingHUD()
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=KLzYVc8lUwApUk965HJEAbcZlcHWoeY8pEYujfEb") else {
            print("URL error")
            return
        }
        
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("------------ Error ------------")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("------------ Response error ------------")
                return
            }
            
            if let mimeType = httpResponse.mimeType, mimeType == "application/json", let data = data {
                let decoder = JSONDecoder()
                do {
                    let dataForView = try decoder.decode(NasaApi.self, from: data)
                    let imageURL = URL(string: dataForView.url)
                    if let image = try? Data(contentsOf: imageURL!){
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: image)
                            self.titleLable.text = dataForView.title
                            self.dateLable.text = dataForView.date
                            self.explanationLabel.text = dataForView.explanation
                            self.copyrightLabel.text = dataForView.copyright
                            self.hideLoadingHUD()
                        }
                    }
                } catch {
                    print("Error in JSON parsing")
                }
            }
        }
        session.resume()
        
    }
}

