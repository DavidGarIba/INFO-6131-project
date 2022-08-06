////
////  favouriteMoviesViewController.swift
////  INFO-6131-project
////
////  Created by Anh Dinh Le on 2022-07-11.
////
//
import UIKit

let notificationKey = "NotificationKey"
let notificationKey2 = "NotificationKey2"

private let reuseIdentifier = "Cell"

class favouriteMoviesViewController: UICollectionViewController {
    var photos: favouriteStruct?
    var requestToken: String?
    var sessionID: String?
    var IDNumber: Int?
    var DataStoreFavourite = dataStoreFavourite.shared
    
    enum section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<section,Int>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: Notification.Name(rawValue: notificationKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Alert1(_:)), name: Notification.Name(rawValue: notificationKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: Notification.Name(rawValue: notificationKey2), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Alert2(_:)), name: Notification.Name(rawValue: notificationKey2), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: nil)
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
   @objc func Alert(Content: String){
        let alert = UIAlertController(title: "Alert Title", message: "\(Content)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  @objc func Alert1(_ notfication:NSNotification){
      
      if let dict = notfication.object as! String? {
         
         let alert = UIAlertController(title: "Favorite Movie", message: "You Added \(dict) Movie To Favorite List", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)
      }
      
  }
 @objc func Alert2(_ notfication:NSNotification){
        
        if let dict = notfication.object as! String? {
           
           let alert = UIAlertController(title: "Favorite Movie", message: "You Removed \(dict) Movie From Favorite List", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
        }
        
    }
    

    @objc func fetchData() {
        DataStoreFavourite.getData( hostURl:"api.themoviedb.org" ,path: "/3/account/{account_id}/favorite/movies", params: ["session_id" :"59e4fe66dd61d82378682ff69f375a2dcf2e6437"], completion: { (result) in
            switch result {
                case .success(let result):
                    self.photos = result
                    
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    switch deviceIdiom {
                        case .phone:
                            self.collectionView.collectionViewLayout = self.configLayout()
                        case .pad:
                            self.collectionView.collectionViewLayout = self.configLayoutIpad()
                        @unknown default:
                            print("Device is unknow")
                    }
                    
                    self.configDataSource(count: result!.total_results)
                    self.collectionView.reloadData()
                
                    break

                case .failure(let error):
                self.Alert(Content: "\(error)")

                    break;
            }
        })
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
    
    private func configLayoutIpad() -> UICollectionViewCompositionalLayout {
        //declare size of the item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.8))
        //declare the item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //give content Insets
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        // dcleare group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        return UICollectionViewCompositionalLayout(section: section)
    }

    func configDataSource(count: Int){

        //Closures DiffableDataSource
        self.dataSource = UICollectionViewDiffableDataSource<section,Int>(collectionView:self.collectionView){ (collectionView,indexPath,number) -> UICollectionViewCell? in

            //dequeue Reusable Cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ItemFavouriteCollectionCollectionViewCell  else {
                fatalError("Index Is Invalid")
            }


            //pass Number of item to label Text

                cell.favouriteLabel.text =  "\(self.photos?.results[number].title.capitalized ?? "error")"
                cell.favouriteImage.contentMode = .scaleAspectFill

                let defaultLink = "https://image.tmdb.org/t/p/w500/"
                let completeLink = defaultLink + (self.photos?.results[number].poster_path ?? "error")

                cell.favouriteImage.downloaded(from: completeLink)



            return cell
        }

        // declear SnapShot section and item
        var initSnapShot = NSDiffableDataSourceSnapshot<section,Int>()
        // insert  section
        initSnapShot.appendSections([.main])
        //insert items
        
        initSnapShot.appendItems(Array(0...(count - 1)))
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

extension favouriteMoviesViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! ItemFavouriteCollectionCollectionViewCell

        self.IDNumber = self.photos!.results[indexPath.row].id
        self.performSegue(withIdentifier: "goToNextPage", sender: self)
    }
}
