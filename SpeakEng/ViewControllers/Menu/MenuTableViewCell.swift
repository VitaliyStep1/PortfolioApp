//
//  MenuTableViewCell.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 19.11.2021.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
