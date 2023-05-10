//
//  CharacterCVC.swift
//  RickMorty
//
//  Created by Victor Truong on 12/8/22.
//

import UIKit
import Alamofire
import AlamofireImage

extension CharacterCVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = itemSpacing * (itemsPerRow - 1) + sectionInsets.left + sectionInsets.right
        let availableWidth = view.frame.width - paddingSpace
        let width = (availableWidth / itemsPerRow).rounded(.towardZero)
        let height = (width * 2.0 / 3.0).rounded(.towardZero)
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}


class CharacterCVC: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    
    private let itemsPerRow: CGFloat = 2
    private let lineSpacing: CGFloat = 12
    private let itemSpacing: CGFloat = 12
    private let sectionInsets = UIEdgeInsets(
        top: 15.0,
        left: 15.0,
        bottom: 15.0,
        right: 15.0)
    
    struct RMCharacterResponse : Decodable {
        var results: [RMCharacter]
        var info : RMInfo
    }
    
    var characters : [RMCharacter] = []
    
    private let cellname = "CharacterCollectionCell"

    private var isFetchInProgress = false
    private var apiUrl : String? = "https://rickandmortyapi.com/api/character"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: cellname, bundle:nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: cellname)
            
        downloadAndParse()
        self.collectionView.prefetchDataSource = self
        // Do any additional setup after loading the view.
        
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.characters.count-1 , section: 0)
        if(indexPaths.contains(lastIndexPath)){
            downloadAndParse()
        }
    }
    
    
    
    
    
    private func downloadAndParse(){
//        AF.request(apiUrl!)
//            .validate()
//            .responseDecodable(of:RMCharacterResponse.self) { response in
//                switch response.result {
//                case .success(let RMCharacters):
//                    self.characters.append(contentsOf: RMCharacters.results)
//                    self.collectionView.reloadData()
//                case .failure(_):
//                    print("Failure of the request")
//                    return
//                }
//            }
//
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
            self.collectionView.reloadData()
        }
        else {
            let startIndex = collectionView.numberOfItems(inSection: 0)
            let endIndex = startIndex + newRowsCount-1
            let indexPathsToReload = (startIndex...endIndex).map { IndexPath(row: $0, section: 0) }
            self.collectionView.insertItems(at: indexPathsToReload)
        }
        self.isFetchInProgress = false
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.characters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellname, for: indexPath) as? CharacterCollectionCell else {
            fatalError("Missing cell")
        }
        
        // Configure the cell
        cell.displayChar(char: self.characters[indexPath.row])
        
        return cell
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        self.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "fromCVCtoVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        if segue.identifier == "fromCVCtoVC" {

            guard let detailVC = segue.destination as? RMCharacterDetailVC else {
            return
            }
            detailVC.rmCharacter = self.characters[indexPath.last!.item]

        }

    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
