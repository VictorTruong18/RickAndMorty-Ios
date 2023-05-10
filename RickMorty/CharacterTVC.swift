//
//  CharacterTVC.swift
//  RickMorty
//
//  Created by Victor Truong on 11/25/22.
//

import Alamofire
import AlamofireImage
import UIKit

class CharacterTVC: UITableViewController, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.characters.count-1 , section: 0)
        if(indexPaths.contains(lastIndexPath)){
            downloadAndParse()
        }
    }
    
    
    struct RMCharacterResponse : Decodable {
        var results: [RMCharacter]
        var info : RMInfo
    }
    
    var characters : [RMCharacter] = []
    
    
    private let cellName = "CharacterCell"
    private var isFetchInProgress = false
    private var apiUrl : String? = "https://rickandmortyapi.com/api/character"
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: cellName, bundle:nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellName)
        downloadAndParse()
        self.tableView.prefetchDataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.characters.count
    }
    
    private func downloadAndParse(){
        //checking if we are already downloading and if we still have something to download
        guard isFetchInProgress == false && apiUrl != nil else {
            return
        }
        AF.request(apiUrl!)
            .validate()
            .responseDecodable(of:RMCharacterResponse.self) { response in
                switch response.result {
                    case .success(let RMCharacters):
                        self.characters.append(contentsOf: RMCharacters.results)
                        //TODO : update your apiUrl from the charResponse.info
                        self.apiUrl = RMCharacters.info.next
                        //smart reloading
                        self.reloadAfterFetching(newRowsCount: RMCharacters.results.count)
                    case .failure(_):
                        print("Failure of the request")
                        return
                }
            }
    }
    
    private func reloadAfterFetching(newRowsCount: Int) {
        let isInitialFetch: Bool = self.characters.count == newRowsCount
        if isInitialFetch {
            self.tableView.reloadData()
        }
        else {
            let startIndex = tableView.numberOfRows(inSection: 0)
            let endIndex = startIndex + newRowsCount-1
            let indexPathsToReload = (startIndex...endIndex).map { IndexPath(row: $0, section: 0) }
            self.tableView.insertRows(at: indexPathsToReload, with: .automatic)
        }
        self.isFetchInProgress = false
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
                as? CharacterCell else {
            fatalError("missing cell")
        }
        
        cell.displayChar(char: self.characters[indexPath.row])
        
        
      

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "rmCharacterCellToDetailView", sender: nil)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        if segue.identifier == "rmCharacterCellToDetailView" {

            guard let detailVC = segue.destination as? RMCharacterDetailVC else {
            return
            }
            detailVC.rmCharacter = self.characters[indexPath.row]

        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterCell.defaultHeight
    }

}
