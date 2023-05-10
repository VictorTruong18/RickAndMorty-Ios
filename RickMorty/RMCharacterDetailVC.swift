//
//  RMCharacterDetailVC.swift
//  RickMorty
//
//  Created by Victor Truong on 12/10/22.
//

import UIKit

class RMCharacterDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = rmCharacter?.episode.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = rmCharacter?.episode[indexPath.item]
        return cell
    }
    
    
    @IBOutlet weak var detailImageView: UIImageView!
    var rmCharacter : RMCharacter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlString = rmCharacter!.image, let url = URL(string: urlString ) {
            detailImageView.af.setImage(withURL: url)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
