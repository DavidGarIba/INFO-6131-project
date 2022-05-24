//
//  GridCollectionViewController.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-05-22.
//

import UIKit

private let reuseIdentifier = "Cell"

class GridCollectionViewController: UICollectionViewController {
   
       
    var photos: Photo?
    var IDNumber: Int?
    
    enum section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<section,Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        collectionView.collectionViewLayout = configLayout()
        configDataSource()
        collectionView.reloadData()
        //print(self.photos?.results.count)
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    func getData(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=8a124cde088692dc4490768ab0797e71&language=en-US&page=1")
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
      
            
            if let MoviePhoto = self.parePhoto(data: data){
            
                    
               self.photos = MoviePhoto
               
                print(self.photos!.results[0].poster_path)
                print(self.photos!.results[0].id)
                //print(self.photos!.results.count)
               
            }
        }
        dataTask.resume()
    }
    
    private func parePhoto(data:Data) -> Photo? // WeatherIconResponse array data type
        {
            let decoder = JSONDecoder()
            var photo: Photo?
            do {
                photo = try decoder.decode(Photo?.self, from: data)
            }
            catch
            {
                print("error parsing weather")
                print(error)
            }
            
            return photo
        }
    
    private func configLayout() -> UICollectionViewCompositionalLayout {
        //declare size of the item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.8))
        //declare the item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //give content Insets
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // dcleare group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
  
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
   

    
    func configDataSource(){
        
        //Closures DiffableDataSource
        self.dataSource = UICollectionViewDiffableDataSource<section,Int>(collectionView:self.collectionView){ (collectionView,indexPath,number) -> UICollectionViewCell? in
            
            //dequeue Reusable Cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ItemCollectionViewCell  else {
                fatalError("Index Is Invalid")
            }
            
      
            //pass Number of item to label Text
        
            
                cell.ItemLabel.text =  "\(self.photos?.results[number].title.capitalized ?? "error")"
                cell.CellImage.contentMode = .scaleAspectFill
                
                let defaultLink = "https://image.tmdb.org/t/p/w500/"
                let completeLink = defaultLink + (self.photos?.results[number].poster_path ?? "error")
                
                cell.CellImage.downloaded(from: completeLink)
        
            
            
            return cell
        }
        
        // declear SnapShot section and item
        var initSnapShot = NSDiffableDataSourceSnapshot<section,Int>()
        // insert  section
        initSnapShot.appendSections([.main])
        //insert items
        initSnapShot.appendItems(Array(0...19))
        //apply to dataSource
        dataSource.apply(initSnapShot)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "goToNextPage"
                {
                let destination = segue.destination as! MovieDetailView
                    destination.ID = self.IDNumber
                }
            }

   
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension GridCollectionViewController {
 
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCollectionViewCell
      
        self.IDNumber = self.photos!.results[indexPath.row].id
        self.performSegue(withIdentifier: "goToNextPage", sender: self)
       
    }
    
}
