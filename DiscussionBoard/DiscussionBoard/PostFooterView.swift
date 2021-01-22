//
//  PostFooterView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 17/1/2564 BE.
//

import UIKit
import RichEditorView

class PostFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyAuthorImageView: UIImageView!
    @IBOutlet var editorView: RichEditorView!
    
    @IBOutlet weak var editorHeight: NSLayoutConstraint!
    
    var didReply: DidAction?
    var didUpdateLayout: DidAction?
    
    class func instanciateFromNib() -> PostFooterView {
        return Bundle.main.loadNibNamed("PostFooterView", owner: nil, options: nil)![0] as! PostFooterView
    }
    
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
        self.replyAuthorImageView.setCircle()
        
        self.replyButton.addTarget(self, action: #selector(self.replyButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func replyButtonPressed(_ sender: UIButton) {
        self.didReply?.handler(self.editorView.html)
        self.editorView.html = ""
    }
}

extension PostFooterView: RichEditorDelegate {
    
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
        self.didUpdateLayout?.handler(self)
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
        self.replyView.isHidden = true
        self.didUpdateLayout?.handler(self)
    }
}
