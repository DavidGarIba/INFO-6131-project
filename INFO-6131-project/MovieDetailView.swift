//
//  SecondViewController.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-05-23.
//

import UIKit

class MovieDetailView: UIViewController {

    var ID: Int?
    
    @IBOutlet weak var Poster: UIImageView!
    @IBOutlet weak var TitleMovie: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(ID!)
        getData()
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    func getData(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(ID!)?api_key=8a124cde088692dc4490768ab0797e71&language=en-US")
        guard let url = url else {
            print("Could not get URL")
            return
        }

        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            print("network call complete")
                        
                        guard error == nil else{
                            print("error")
                            return
                        }
                        guard let data = data else{
                            print("no data found")
                            return
                        }
      
            
            if let MovieDetail = self.pareMovieDetail(data: data){
                DispatchQueue.main.async {
                    self.TitleMovie.text = MovieDetail.title
                    
                    let defaultLink = "https://image.tmdb.org/t/p/w500/"
                    let completeLink = defaultLink + MovieDetail.poster_path
                    
                    self.Poster.downloaded(from: completeLink)
                }
            
            }
        }
        dataTask.resume()
    }
    
    private func pareMovieDetail(data:Data) -> MovieDetailStruct? // WeatherIconResponse array data type
        {
            let decoder = JSONDecoder()
            var movieDetail: MovieDetailStruct?
            do {
                movieDetail = try decoder.decode(MovieDetailStruct?.self, from: data)
            }
            catch
            {
                print("error parsing weather")
                print(error)
            }
            
            return movieDetail
        }
}

