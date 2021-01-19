//
//  PostHeaderView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import UIKit

let maxReplyList = 2

class PostHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var seeMoreReplyButton: UIButton!
    
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
                let font = self.textView.font ?? textViewFont
                self.textView.attributedText = post.body.html2Atb(font: font)
                
                if post.isLiked {
                    
                }
                self.linkLabel.textColor = post.isLiked ? .primary() : .secondary_50()
                self.linkLabel.text = post.countLikes.textNumber(many: "like_unit")
                
                self.updateUIColor(isPin: post.isPinned)
                
                self.isReplyAll = post.isReplyFull()
                if post.countReplies > maxReplyList {
                    if self.isReplyAll  {
                        self.seeMoreReplyButton.isHidden = true
                    } else {
                        self.seeMoreReplyButton.isHidden = false
                        var seeMoreText = "see previous replies" + "(\(post.countReplies)"
                        self.seeMoreReplyButton.setTitle(seeMoreText, for: .normal)
                    }
                }
            }
        }
    }
    
    class func instanciateFromNib() -> PostHeaderView {
        return Bundle.main.loadNibNamed("PostHeaderView", owner: nil, options: nil)![0] as! PostHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        self.replyLabel.font = FontHelper.getFontSystem(.small , font: .bold)
        
        self.dateLabel.textColor = .secondary_25()
        self.linkLabel.textColor = isPin ? .primary() : .secondary_50()
        self.replyLabel.textColor = isPin ? .primary() : .secondary_50()
    }
    
    @IBAction func seeMoreReplyPressed(_ sender: UIButton) {
        self.isReplyAll = true
        self.seeMoreReplyButton.isHidden = true
        self.didReload?.handler(self)
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
