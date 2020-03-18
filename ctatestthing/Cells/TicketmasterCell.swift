//
//  TicketmasterTableViewCell.swift
//  ctatestthing
//
//  Created by Ahad Islam on 3/17/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import Kingfisher

class TicketmasterCell: UITableViewCell {

    @IBOutlet weak var ticketImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureCell(_ event: Event) {
        label.text = event.name
        secondLabel.text = event.dates.start.localDate
        
        guard let image = event.images.first, let url = URL(string: image.url) else {
            return
        }
        
        ticketImageView.kf.setImage(with: url)
    }

}
