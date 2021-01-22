//
//  DCPostView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit
import RichEditorView

class DCPostView: DCBasePostView {
    
    class func instanciateFromNib() -> DCPostView {
        return Bundle.main.loadNibNamed("DCPostView", owner: nil, options: nil)![0] as! DCPostView
    }
    
}


class DCBasePostView: UIView {
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editorView: RichEditorView!
    @IBOutlet weak var editorHeight: NSLayoutConstraint!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var seeMoreReplyButton: UIButton!
    
    var editorHelper:EditorHelper!
    let textViewFont = FontHelper.getFontSystem(.small, font: .text)
    var isReplyAll = false
    var didReload: DidAction?
    var replyList:[DiscussionReplyResult]?
    
    var post: DiscussionPostResult? {
        didSet {
            if let post = self.post {
                if let author = post.author {
                    self.authorImageView.setImage(author.image, placeholderImage: nil)
                    self.authorNameLabel.text = author.name
                }
                self.dateLabel.text = post.datetimeCreate.dateTimeAgo()
                let font = self.textView.font ?? textViewFont
                self.textView.attributedText = post.body.html2Atb(font: font)
                
                self.linkLabel.textColor = post.isLiked ? .primary() : .secondary_50()
                self.linkLabel.text = post.countLikes.textNumber(many: "like_unit")
                
                self.updateUIColor(isPin: post.isPinned)
                
                self.isReplyAll = post.isReplyFull()
                
                
            }
        }
    }
    
    func updateReplyUI(post: DiscussionPostResult) {
        if let post = self.post {
            if post.countReplies > maxReplyList {
                if self.isReplyAll  {
                    self.seeMoreReplyButton.isHidden = true
                } else {
                    self.seeMoreReplyButton.isHidden = false
                    let countLeft = post.countReplies - maxReplyList
                    let seeMoreText = "see previous replies" + "(\(countLeft))"
                    self.seeMoreReplyButton.setTitle(seeMoreText, for: .normal)
                }
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editView.isHidden = true
        self.editorHelper = EditorHelper()
        self.editorHelper.cancelButton = self.cancelButton
        self.editorHelper.editView = self.editView
        self.editorHelper.editButton = self.editButton
        self.editorHelper.editorView = self.editorView
        self.editorHelper.editorHeight = self.editorHeight
        
        self.seeMoreReplyButton.isHidden = true
        self.authorImageView.setCircle()
        self.authorNameLabel.font = FontHelper.getFontSystem(.small , font: .medium)
        self.textView.font = textViewFont
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:))))
        
        self.updateUIColor(isPin: false)
        
        self.seeMoreReplyButton.imageView?.tintColor = .secondary()
        self.seeMoreReplyButton.tintColor = .secondary()
        self.seeMoreReplyButton.titleLabel?.font = FontHelper.getFontSystem(.small , font: .text)
    }
    
    func updateUIColor(isPin:Bool) {
        self.dateLabel.font = FontHelper.getFontSystem(.small , font: .text)
        self.linkLabel.font = FontHelper.getFontSystem(.small , font: .bold)
        self.replyButton.titleFont = FontHelper.getFontSystem(.small , font: .bold)
        
        let color = isPin ? .primary() : UIColor(hex: "EFEFF0")
        self.dateLabel.textColor = color
        self.linkLabel.textColor = color
        self.replyButton.setTitleColor(color, for: .normal)
        self.likeButton.tintColor = color
    }
    
    @IBAction func seeMoreReplyPressed(_ sender: UIButton) {
        self.isReplyAll = true
        self.seeMoreReplyButton.isHidden = true
        self.didReload?.handler(self)
    }
    
    @IBAction func replyPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func canclePressed(_ sender: UIButton) {
        
    }

    @objc func tapIconHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        //delegate?.tapSection(self, content: self.content)
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? PostHeaderView else {
            return
        }
        
        //delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //arrowImageView.rotate(collapsed ? 0.0 : .pi)
    }
}
