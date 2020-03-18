//
//  RijksCell.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/18/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import Kingfisher

protocol RijksCellDelegate: AnyObject {
    func didPressButton(cell: RijksCell, object: ArtObject)
}

class RijksCell: UITableViewCell {

    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: RijksCellDelegate?
    var object: ArtObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        artImageView.image = nil
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.didPressButton(cell: self, object: object!)
    }
    
    public func configureCell(object: ArtObject, onFavorite: Bool) {
        self.object = object
        artImageView.kf.setImage(with: URL(string: object.webImage.url))
        label.text = object.title
        
        if !onFavorite {
            FirestoreSession.session.isItemFavorited(object, experience: .rijksMuseum) { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let bool):
                    DispatchQueue.main.async {
                        bool ? self?.button.setImage(UIImage(systemName: "heart.fill"), for: .normal) : self?.button.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }
            }
            
        } else {
            button.isHidden = true
        }
    }
    
}
