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
    @IBOutlet weak var likeButton: UIButton!
    
    let textViewFont = FontHelper.getFontSystem(.small, font: .text)
    
    var isPostPin = false
    var didLikePressed: DidAction?
    
    var reply: DiscussionReplyResult? {
        didSet {
            if let reply = self.reply {
                if let author = reply.author {
                    self.authorImageView.setImage(author.image, placeholderImage: nil)
                    self.authorNameLabel.text = author.name
                }
                self.dateLabel.text = reply.datetimeCreate.dateTimeAgo()
                let font = self.textView.font ?? textViewFont
                self.textView.attributedText = reply.body.html2Atb(font: font)
                
                self.linkLabel.textColor = reply.isLiked ? .primary() : .secondary_50()
                self.linkLabel.text = reply.countLikes.textNumber(many: "like_unit")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.authorImageView.setCircle()
        self.authorNameLabel.font = FontHelper.getFontSystem(.small , font: .medium)
        self.textView.font = textViewFont
        self.likeButton.addTarget(self, action: #selector(self.likeButtonPressed(_:)), for: .touchUpInside)
        self.updateUIColor()
    }
    
    @objc func likeButtonPressed(_ sender: UIButton) {
        self.didLikePressed?.handler(self.reply)
    }
    
    func updateUIColor() {
        self.dateLabel.font = FontHelper.getFontSystem(.small , font: .text)
        self.linkLabel.font = FontHelper.getFontSystem(.small , font: .bold)
        self.replyLabel.font = FontHelper.getFontSystem(.small , font: .bold)
        let gray = UIColor(hex: "8F9295")
        self.dateLabel.textColor = gray
        self.linkLabel.textColor = gray
        self.replyLabel.textColor = gray
        self.likeButton.tintColor = gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
