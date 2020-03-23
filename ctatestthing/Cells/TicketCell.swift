//
//  TicketCell.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/17/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import Kingfisher

protocol TicketCellDelegate: AnyObject {
    func didSelectTicket(_ ticketCell: TicketCell, ticket: Event)
}


class TicketCell: UITableViewCell {
    
    @IBOutlet weak var ticketImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: TicketCellDelegate?
    var event: Event?
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.didSelectTicket(self, ticket: event!)
    }
    
    public func configureCell(_ event: Event, onFavorite: Bool) {
        self.event = event
        label.text = event.name
        secondLabel.text = event.dates.start.localDate
        
        if !onFavorite {
            FirestoreSession.session.isItemFavorited(event, experience: .ticketMaster) { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let bool):
                    DispatchQueue.main.async {
                        bool ? self?.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : self?.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }
            }
            
        } else {
            favoriteButton.isHidden = true
        }
        
        
        guard let image = event.images.first, let url = URL(string: image.url) else {
            return
        }
        
        ticketImageView.kf.setImage(with: url)
    }
    
}
