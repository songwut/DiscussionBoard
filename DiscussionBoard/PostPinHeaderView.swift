//
//  PostPinHeaderView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 18/1/2564 BE.
//

import UIKit
import RichEditorView

class PostPinHeaderView: PostHeaderView {

    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet var editorView: RichEditorView!
    @IBOutlet weak var replyAuthorImageView: UIImageView!
    
    var replyAuthor: AuthorResult? {
        didSet {
            if let replyAuthor = self.replyAuthor {
                self.replyAuthorImageView.setImage(replyAuthor.image, placeholderImage: nil)
                
            }
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
    }

}

extension PostPinHeaderView: RichEditorDelegate {
    
}

