//
//  SecondViewController.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-05-23.
//

import UIKit
import AVKit
import XCDYouTubeKit



class MovieDetailView: UIViewController {

    var ID: Int?
    var Title: String?
    var Flag: Bool = false
    var DataStoreMovieDetailView = dataStoreMovieDetailView.shared
    var DataStoreDirector = dataStoreDirector.shared
    var DataStoreMarkFavourite = dataStoreMarkFavourite.shared
    var DataStoreMarkFavouriteFailed = dataStoreMarkFavouriteFailed.shared
    var DataStorePlayVideo = dataStorePlayVideo.shared
    
    var Director = [Directing]()
    
    @IBOutlet weak var Poster: UIImageView!
    @IBOutlet weak var TitleMovie: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func Alert(Content: String){
        let alert = UIAlertController(title: "Alert Title", message: "\(Content)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playVideoButton(_ sender: UIButton) {
        
        DataStorePlayVideo.getData( hostURl:"api.themoviedb.org" ,path: "/3/movie/\(ID!)/videos", params: nil, completion: { (result) in
            switch result {
                case .success(let result):
                
                guard let result = result else{
                    print("no data found")
                    return
                }
                print(result.results[0].key)
                self.videoHandle(Key: result.results[0].key)
                    
                case .failure(let error):
                self.Alert(Content:"\(error)")
                    
                    break;
            }
            
        })
        
    }
    
    func videoHandle(Key: String){
        let playerVC = AVPlayerViewController()
        present(playerVC, animated: true, completion: nil)
        XCDYouTubeClient.default().getVideoWithIdentifier(Key) {[weak self, weak playerVC] (video, error) in
            if let _ = error {
                self?.dismiss(animated: true, completion: nil)
                return
            }
            guard let video = video else {
                self?.dismiss(animated: true,completion: nil)
                return
            }
            
            let streamURL: URL
            if let url = video.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] {
                streamURL = url
            }else if let url = video.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue]{
                streamURL = url
            }else if let url = video.streamURLs[XCDYouTubeVideoQuality.small240.rawValue]{
                streamURL = url
            }else if let urlDict = video.streamURLs.first {
                streamURL = urlDict.value
            }else {
                self?.dismiss(animated: true,completion: nil)
                return
            }
            
            playerVC?.player = AVPlayer(url: streamURL)
            playerVC?.player?.play()
            
        }
    }
    
    @IBAction func addFavourite(_ sender: UIButton) {
      
        // Add favorite
        DataStoreMarkFavourite.getData( hostURl:"api.themoviedb.org" ,path: "/3/account/12431774/favorite", params: ["session_id": "59e4fe66dd61d82378682ff69f375a2dcf2e6437"],mediaID: ID!, completion: { (result) in
            switch result {
                case .success(let result):
                
                guard let result = result else{
                    print("no data found")
                    return
                }
                
                self.Alert(Content:"\(result.status_message)")
                    break
                    
                case .failure(let error):
                self.Alert(Content:"\(error)")
                    
                    break;
            }
            
        })
        
        // Move to Favorite screen
        self.performSegue(withIdentifier: "goToNextPage", sender: self)
        
        // Call  NotificationCenter
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: Title)
       
    }
    
    @IBAction func RemoveFavourite(_ sender: UIButton) {
        // Remove favorite
        DataStoreMarkFavouriteFailed.getData( hostURl:"api.themoviedb.org" ,path: "/3/account/12431774/favorite", params: ["session_id": "59e4fe66dd61d82378682ff69f375a2dcf2e6437"],mediaID: ID!, completion: { (result) in
            switch result {
                case .success(let result):
                
                guard let result = result else{
                    print("no data found")
                    return
                }
                
                self.Alert(Content:"\(result.status_message)")
                    break
                    
                case .failure(let error):
                self.Alert(Content:"\(error)")
                    
                    break;
            }
            
        })
        
        // Move to Favorite screen
        self.performSegue(withIdentifier: "goToNextPage", sender: self)
        
        // Call  NotificationCenter
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey2), object: Title)
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "goToNextPage"
                {
                    let destination = segue.destination as! favouriteMoviesViewController
                }
    }
    
  @objc private func fetchData() {
        DataStoreMovieDetailView.getData( hostURl:"api.themoviedb.org" ,path: "/3/movie/\(ID!)", params: ["language" :"en-US"], completion: { (result) in
            switch result {
                case .success(let result):
                
                guard let result = result else{
                    print("no data found")
                    return
                }
                
                self.TitleMovie.text = result.title
                self.Title = result.title
                self.overViewLabel.text = result.overview
                self.rateLabel.text = "\(result.vote_average * 10)%"
               
                let defaultLink = "https://image.tmdb.org/t/p/w500/"
                let completeLink = defaultLink + result.poster_path
               
                self.Poster.downloaded(from: completeLink)
                    break
                    
                case .failure(let error):
                self.Alert(Content:"\(error)")
                    
                    break;
            }
            
        })
        
    }
    
   @objc private func fetchDirector() {
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
                self.Alert(Content:"\(error)")
                    
                    break;
            }
            
        })
        
    }

}

