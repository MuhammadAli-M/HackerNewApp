//
//  StoryCell.swift
//  HackerNews
//
//  Created by Muhammad Adam on 2/14/19.
//  Copyright © 2019 Muhammad Adam. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
