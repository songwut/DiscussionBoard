//
//  PostPinHeaderView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 18/1/2564 BE.
//

import UIKit
import RichEditorView

class PostPinHeaderView: PostHeaderView {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var editorView: RichEditorView!
    @IBOutlet weak var replyAuthorImageView: UIImageView!
    
    @IBOutlet weak var editorHeight: NSLayoutConstraint!
    
    var didReply: DidAction?
    var didUpdateLayout: DidAction?
    
    var didLoadReply: DidAction?
    
    var replyAuthor: AuthorResult? {
        didSet {
            if let replyAuthor = self.replyAuthor {
                self.replyAuthorImageView.setImage(replyAuthor.image, placeholderImage: nil)
                
            }
            //self.borderView.updateLayout()
            //self.borderView.backgroundColor = .primary_10()
            //self.borderView.layer.addBorder(edge: .top, color: .primary(), thickness: 1.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editorView.delegate = self
        self.replyView.isHidden = true
        self.seeMoreReplyButton.isHidden = true
        self.replyAuthorImageView.setCircle()
        self.authorNameLabel.font = FontHelper.getFontSystem(.small , font: .medium)
        self.textView.font = textViewFont
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:))))
        
        self.replyButton.addTarget(self, action: #selector(self.replyButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func replyButtonPressed(_ sender: UIButton) {
        self.replyView.isHidden = true
        self.didReply?.handler(self.editorView.html)
        self.editorView.html = ""
    }

}

extension PostPinHeaderView: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty || self.editorView.html == "<br>" {
            self.replyButton.setStyleColor(false, titleColor: .white, bgColor: .lightGray)
        } else {
            self.replyButton.setStyleColor(true, titleColor: .white, bgColor: .primary())
        }
    }
    
    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) {
        
        if height < DBMaxHeightReply {
            let h = height <= 33 ? 33 : height
            self.editorHeight.constant = CGFloat(h)
            self.didUpdateLayout?.handler(CGFloat(h))
            print("heightDidChange: \(h)")
        }
    }
    
    func richEditorTookFocus(_ editor: RichEditorView) {
        self.replyView.isHidden = false
        self.replyButton.setStyleColor(false, titleColor: .white, bgColor: .lightGray)
        
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
        self.replyView.isHidden = true
    }
}

