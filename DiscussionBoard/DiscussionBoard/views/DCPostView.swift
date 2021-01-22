//
//  DCPostView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit
import RichEditorView

class DCPostView: DCBasePostView {
    
    @IBOutlet weak var itemStackView: UIStackView!
    
    class func instanciateFromNib() -> DCPostView {
        return Bundle.main.loadNibNamed("DCPostView", owner: nil, options: nil)![0] as! DCPostView
    }
    
}

class DCReactionView: UIView {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    let gray = UIColor(hex: "8F9295")
    var didLikePressed: DidAction?
    var didreplyPressed: DidAction?
    var content:Any?
    
    func reaction(_ isLiked: Bool, _ countLikes:Int) {
        let numText = countLikes.shorted()
        let unit = countLikes.textNumber(many: "like_unit").split(separator: Character(" "))
        let likeText = numText + " \(unit[1])"
        
        if countLikes == 0 {
            self.likeButton.setTitle("like".localized(), for: .normal)
        } else {
            self.likeButton.setTitle(likeText, for: .normal)
        }
        
        if isLiked {
            self.likeButton.tintColor = .primary()
            self.likeButton.setTitleColor(.primary(), for: .normal)
        } else {
            self.likeButton.tintColor = self.gray
            self.likeButton.setTitleColor(self.gray, for: .normal)
        }
    }
    
    func prepareUI() {
        self.dateLabel.font = .font(.small, .text)
        self.replyButton.titleFont = .font(.small, .bold)
        self.likeButton.titleFont = .font(.small, .bold)
        self.replyButton.addTarget(self, action: #selector(self.replyPressed(_:)), for: .touchUpInside)
        self.likeButton.addTarget(self, action: #selector(self.replyPressed(_:)), for: .touchUpInside)
        
    }
    
    func updateUIColor(isPin:Bool) {
        self.dateLabel.font = FontHelper.getFontSystem(.small , font: .text)
        self.replyButton.titleFont = FontHelper.getFontSystem(.small , font: .bold)
        
        self.dateLabel.textColor = self.gray
        self.replyButton.setTitleColor(self.gray, for: .normal)
        self.likeButton.tintColor = self.gray
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        self.didLikePressed?.handler(self.content)
    }
    
    @IBAction  func replyPressed(_ sender: UIButton) {
        self.didreplyPressed?.handler(self.content)
    }
}


class DCBasePostView: DCReactionView {
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editorView: RichEditorView!
    @IBOutlet weak var editorHeight: NSLayoutConstraint!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var seeMoreReplyButton: UIButton!
    
    var editorHelper:EditorHelper!
    let textViewFont = FontHelper.getFontSystem(.small, font: .text)
    var isReplyAll = false
    var didReload: DidAction?
    var replyList:[DiscussionReplyResult]?
    
    var post: DiscussionPostResult? {
        didSet {
            if let post = self.post {
                self.content = post
                if let author = post.author {
                    self.authorImageView.setImage(author.image, placeholderImage: nil)
                    self.authorNameLabel.text = author.name
                }
                self.dateLabel.text = post.datetimeCreate.dateTimeAgo()
                let font = self.textView.font ?? textViewFont
                self.textView.attributedText = post.body.html2Atb(font: font)
                
                self.updateUIColor(isPin: post.isPinned)
                
                self.isReplyAll = post.isReplyFull()
                
                self.reaction(post.isLiked, post.countLikes)
                
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
        self.editorHelper.borderView = self.editView.superview
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
        
        self.seeMoreReplyButton.borderColor = UIColor(hex: "AFB1B4")
        self.seeMoreReplyButton.imageView?.tintColor = UIColor(hex: "8F9295")
        self.seeMoreReplyButton.tintColor = UIColor(hex: "8F9295")
        self.seeMoreReplyButton.titleLabel?.font = FontHelper.getFontSystem(.small , font: .text)
    }
    
    
    
    @IBAction func seeMoreReplyPressed(_ sender: UIButton) {
        self.isReplyAll = true
        self.seeMoreReplyButton.isHidden = true
        self.didReload?.handler(self)
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
