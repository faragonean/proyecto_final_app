//
//  FormTestTableViewCell.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 13/07/22.
//

import UIKit

class FormTestTableViewCell: UITableViewCell {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var radioImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
