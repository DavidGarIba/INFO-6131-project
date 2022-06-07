//
//  SecondViewController.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-05-23.
//

import UIKit

class MovieDetailView: UIViewController {

    var ID: Int?
    var DataStoreMovieDetailView = dataStoreMovieDetailView.shared
    var DataStoreDirector = dataStoreDirector.shared
    
    var Director = [Directing]()
    
    @IBOutlet weak var Poster: UIImageView!
    @IBOutlet weak var TitleMovie: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(ID!)
        fetchData()
        fetchDirector()
    }
    
    @IBAction func BackBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    private func fetchData() {
        DataStoreMovieDetailView.getData( hostURl:"api.themoviedb.org" ,path: "/3/movie/\(ID!)", params: ["language" :"en-US"], completion: { (result) in
            switch result {
                case .success(let result):
                
                guard let result = result else{
                    print("no data found")
                    return
                }
                
                self.TitleMovie.text = result.title
                self.overViewLabel.text = result.overview
                self.rateLabel.text = "\(result.vote_average * 10)%"
               
                let defaultLink = "https://image.tmdb.org/t/p/w500/"
                let completeLink = defaultLink + result.poster_path
               
                self.Poster.downloaded(from: completeLink)
                    break
                    
                case .failure(let error):
                    print(error)
                    
                    break;
            }
            
        })
        
    }
    
    private func fetchDirector() {
        DataStoreDirector.getData( hostURl:"api.themoviedb.org" ,path: "/3/movie/\(ID!)/credits", params: ["language" :"en-US"], completion: { (result) in
            switch result {
                case .success(let result):
                
                guard let result = result else{
                    print("no data found")
                    return
                }
                
                self.Director = result.crew
                for director in self.Director {
                    if director.known_for_department == "Directing"{
                        self.directorLabel.text = director.name
                    }
                }
                    break
                    
                case .failure(let error):
                    print(error)
                    
                    break;
            }
            
        })
        
    }

}

