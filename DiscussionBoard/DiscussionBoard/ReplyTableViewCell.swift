//
//  ReplyTableViewCell.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    let textViewFont = FontHelper.getFontSystem(.small, font: .text)
    
    var isPostPin = false
    
    var reply: DiscussionReplyResult? {
        didSet {
            if let reply = self.reply {
                if let author = reply.author {
                    self.authorImageView.setImage(author.image, placeholderImage: nil)
                    self.authorNameLabel.text = author.name
                }
                let font = self.textView.font ?? textViewFont
                self.textView.attributedText = reply.body.html2Atb(font: font)
                
                self.linkLabel.textColor = reply.isLiked ? .primary() : .secondary_50()
                self.linkLabel.text = reply.countLikes.textNumber(many: "like_unit")
            }
            self.borderView.updateLayout()
            let pinColorBg: UIColor =  self.isPostPin ? .primary_10() : .clear
            let pinBorder: UIColor = self.isPostPin ? .primary() : .clear
            self.borderView.isHidden = !self.isPostPin
            self.borderView.backgroundColor = pinColorBg
            self.borderView.layer.addBorder(edge: .left, color: pinBorder, thickness: 1.0)
            self.borderView.layer.addBorder(edge: .right, color: pinBorder, thickness: 1.0)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.borderView.isHidden = true
        
        self.authorImageView.setCircle()
        self.authorNameLabel.font = FontHelper.getFontSystem(.small , font: .medium)
        self.textView.font = textViewFont
        
        self.updateUIColor()
    }
    
    func updateUIColor() {
        self.dateLabel.font = FontHelper.getFontSystem(.small , font: .text)
        self.linkLabel.font = FontHelper.getFontSystem(.small , font: .bold)
        self.replyLabel.font = FontHelper.getFontSystem(.small , font: .bold)
        
        self.dateLabel.textColor = .secondary()
        self.linkLabel.textColor = .secondary()
        self.replyLabel.textColor = .secondary()
        self.linkButton.tintColor = .secondary()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
