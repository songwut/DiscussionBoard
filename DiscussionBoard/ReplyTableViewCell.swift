//
//  ReplyTableViewCell.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var reply: DiscussionReplyResult? {
        didSet {
            if let reply = self.reply {
                //if let author = reply.author
                //self.authorImageView.setim
                self.textView.attributedText = reply.body.html2AttributedString
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
