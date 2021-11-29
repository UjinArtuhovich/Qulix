//
//  MainTableViewCell.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 27.11.21.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var linkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with data: MainModel) {
        linkLabel.text = data.link
    }
    
}
