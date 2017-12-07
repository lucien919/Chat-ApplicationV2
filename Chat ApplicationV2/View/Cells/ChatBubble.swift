//
//  ChatBubble.swift
//  Chat ApplicationV2
//
//  Created by Mac on 12/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ChatBubble: UITableViewCell {
    @IBOutlet weak var bubble:ChatContentView!
    @IBOutlet weak var label:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.textColor = UIColor.magenta
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib:UINib{
        return UINib(nibName: "ChatBubble", bundle: nil)
    }
    
}
