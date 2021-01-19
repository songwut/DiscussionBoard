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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    let textViewFont = FontHelper.getFontSystem(.small, font: .text)
    
    var reply: DiscussionReplyResult? {
        didSet {
            if let reply = self.reply {
                if let author = reply.author {
                    self.authorImageView.setImage(author.image, placeholderImage: nil)
                    self.authorNameLabel.text = author.name
                }
                let font = self.textView.font ?? textViewFont
                self.textView.attributedText = reply.body.html2Atb(font: font)
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.authorImageView.setCircle()
        self.authorNameLabel.font = FontHelper.getFontSystem(.small , font: .medium)
        self.textView.font = textViewFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
