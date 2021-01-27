//
//  DCReplyView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit

class DCReplyView: DCReactionView {
    
    class func instanciateFromNib() -> DCReplyView {
        return Bundle.main.loadNibNamed("DCReplyView", owner: nil, options: nil)![0] as! DCReplyView
    }
    
    @IBOutlet weak var marginLeft: NSLayoutConstraint!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    let textViewFont = FontHelper.getFontSystem(.small, font: .text)
    
    var isPostPin = false
    
    var reply: DiscussionReplyResult? {
        didSet {
            if let reply = self.reply {
                self.content = reply
                if let author = reply.author {
                    self.authorImageView.setImage(author.image, placeholderImage: nil)
                    self.authorNameLabel.text = reply.authorTitle()
                }
                self.dateLabel.text = reply.datetimeCreate.dateTimeAgo()
                let font = self.textView.font ?? textViewFont
                self.textView.attributedText = reply.body.html2Atb(font: font)
                
                self.reaction(reply.isLiked, reply.countLikes)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.authorImageView.setCircle()
        self.authorNameLabel.font = FontHelper.getFontSystem(.small , font: .medium)
        self.textView.font = textViewFont
        self.updateUIColor()
    }
    
    func updateUIColor() {
        self.dateLabel.font = FontHelper.getFontSystem(.small , font: .text)
        self.replyButton.titleFont = FontHelper.getFontSystem(.small , font: .bold)
        self.dateLabel.textColor = self.gray
        self.replyButton.setTitleColor(self.gray, for: .normal)
        self.likeButton.tintColor = self.gray
        self.likeButton.setTitleColor(self.gray, for: .normal)
    }

}
