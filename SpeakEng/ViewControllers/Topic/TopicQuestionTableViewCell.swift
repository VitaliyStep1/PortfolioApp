//
//  TopicQuestionTableViewCell.swift
//  SpeakEng
//
//  Created by Vitaliy Stepanenko on 05.12.2021.
//

import UIKit

class TopicQuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
