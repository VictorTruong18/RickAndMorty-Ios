//
//  CharacterCell.swift
//  RickMorty
//
//  Created by Victor Truong on 11/25/22.
//

import UIKit
import AlamofireImage

class CharacterCell: UITableViewCell {

    @IBOutlet weak var charImageView: UIImageView!
    
    @IBOutlet weak var Origin: UILabel!
    @IBOutlet weak var Species: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    static let defaultHeight : CGFloat = 100
    
    func displayChar(char: RMCharacter) {
        if let urlString = char.image, let url = URL(string: urlString ) {
            charImageView.af.setImage(withURL: url)
        }
        Species.text = char.species
        Name.text = char.name
        Origin.text = char.origin.name
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        //cancel the current download
        charImageView.af.cancelImageRequest()
        //remove the previous image
        charImageView.image = nil
        
    }
}
