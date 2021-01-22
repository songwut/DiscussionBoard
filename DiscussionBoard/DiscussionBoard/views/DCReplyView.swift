//
//  DCReplyView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit
import RichEditorView

class DCReplyView: UIView {
    
    class func instanciateFromNib() -> DCReplyView {
        return Bundle.main.loadNibNamed("DCReplyView", owner: nil, options: nil)![0] as! DCReplyView
    }
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editorView: RichEditorView!
    @IBOutlet weak var editorHeight: NSLayoutConstraint!
    
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
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
        self.editView.isHidden = true
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
        self.replyButton.titleFont = FontHelper.getFontSystem(.small , font: .bold)
        let gray = UIColor(hex: "EFEFF0")
        self.dateLabel.textColor = gray
        self.linkLabel.textColor = gray
        self.replyButton.setTitleColor(gray, for: .normal)
        self.likeButton.tintColor = gray
    }

}
