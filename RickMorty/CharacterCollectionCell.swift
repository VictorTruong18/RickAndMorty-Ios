//
//  CharacterCollectionCell.swift
//  RickMorty
//
//  Created by Victor Truong on 12/8/22.
//

import UIKit
import AlamofireImage

class CharacterCollectionCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    

    
    func displayChar(char: RMCharacter) {
        if let urlString = char.image, let url = URL(string: urlString ) {
            imageView.af.setImage(withURL: url)
            
        }
        label.text = char.name

    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        //cancel the current download
        imageView.af.cancelImageRequest()
        //remove the previous image
        imageView.image = nil
        
    }
    


}
