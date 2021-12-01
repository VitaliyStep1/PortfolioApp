//
//  SettingsTableViewCell.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 24.11.2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
