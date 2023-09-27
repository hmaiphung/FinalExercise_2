//
//  DataUserTableViewCell.swift
//  FinalExercise_2
//
//  Created by Phung Huy on 20/09/2023.
//

import UIKit

class DataUserTableViewCell: UITableViewCell {

  
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnHtml: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
