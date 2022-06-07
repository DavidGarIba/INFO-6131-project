//
//  SearchViewController.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-06-06.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
        var celId = "cell"
        let searchController = UISearchController(searchResultsController:nil)
        var DataStoreSearchViewController = dataStoreSearchViewController.shared
        var items = [SearchDetail]()
        var idCell = 0
       
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.dataSource = self
            
            customSearchController()
     
        }
    @IBAction func clearBtn(_ sender: UIButton) {
        searchController.searchBar.text = ""
        self.tableView.reloadData()
    }
    
    private func fetchData(queryString: String) {
        DataStoreSearchViewController.getData( hostURl:"api.themoviedb.org" ,path: "/3/search/movie", params: ["query" : "\(queryString)"], completion: { (result) in
            switch result {
                case .success(let result):
                
                guard let result = result else{
                    print("no data found")
                    return
                }
                self.items = result.results
                self.tableView.reloadData()
                    break
                    
                case .failure(let error):
                    print(error)
                    
                    break;
            }
        })
    }
    
    
        func customSearchController(){
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            tableView.tableHeaderView = searchController.searchBar
            searchController.searchBar.tintColor = .white
            searchController.searchBar.showsCancelButton = true
            searchController.searchBar.placeholder = "Please Enter Movie Name"
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "goToNextPage"
                {
                let destination = segue.destination as! MovieDetailView
                    destination.ID = self.idCell
                }
            }

    
    }

    extension SearchViewController:UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if searchController.isActive && searchController.searchBar.text != ""{
                return items.count
            }
            return NullableList.count
                
        }
 
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell =  tableView.dequeueReusableCell(withIdentifier: celId,for:indexPath)
            
            let Cell:String
            
            if searchController.isActive && searchController.searchBar.text != ""{

                Cell = items[indexPath.row].original_title
            } else{
                Cell = NullableList[indexPath.row].original_title
            }
            
            cell.textLabel?.text =  Cell
            return cell
        }
    }



    extension SearchViewController: UITableViewDelegate{
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.idCell = items[indexPath.row].id
            self.performSegue(withIdentifier: "goToNextPage", sender: self)
            
        }
        
    }

    extension SearchViewController: UISearchResultsUpdating{
        func updateSearchResults(for searchController: UISearchController) {
            fetchData(queryString: searchController.searchBar.text ?? "")
            self.tableView.reloadData()
        }
    }
