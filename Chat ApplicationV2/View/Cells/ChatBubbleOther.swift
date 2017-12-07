//
//  ChatBubbleOther.swift
//  Chat ApplicationV2
//
//  Created by Mac on 12/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ChatBubbleOther: UITableViewCell {
    @IBOutlet weak var bubble:ChatContentView!
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.textColor = UIColor.cyan
        name.textColor = UIColor.cyan
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib:UINib{
        return UINib(nibName: "ChatBubbleOther", bundle: nil)
    }
    
}
