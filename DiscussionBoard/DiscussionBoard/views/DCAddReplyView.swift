//
//  DCAddReplyView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit
import RichEditorView

class DCAddReplyView: UIView {

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyAuthorImageView: UIImageView!
    @IBOutlet weak var editorView: RichEditorView!
    @IBOutlet weak var editorHeight: NSLayoutConstraint!
    @IBOutlet weak var limitLabel: UILabel!
    
    let limitCount = 2000
    var didReply: DidAction?
    
    var post: DiscussionPostResult?
    
    class func instanciateFromNib() -> DCAddReplyView {
        return Bundle.main.loadNibNamed("DCAddReplyView", owner: nil, options: nil)![0] as! DCAddReplyView
    }
    
    var profile: ProfileResult? {
        didSet {
            if let profile = self.profile {
                self.replyAuthorImageView.setImage(profile.image, placeholderImage: nil)
                
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

extension DCAddReplyView: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty || self.editorView.html == "<br>" {
            self.replyButton.setStyleColor(false, titleColor: .white, bgColor: DCStyle.disable())
        } else {
            self.replyButton.setStyleColor(true, titleColor: .white, bgColor: DCStyle.active())
        }
        
        DispatchQueue.main.async {
            let text = editor.html.removeHtml
            self.limitLabel.text = "\(text.count)/\(self.limitCount)"
            if text.count > self.limitCount {
                self.replyButton.setStyleColor(false, titleColor: .white, bgColor: DCStyle.disable())
            }
        }
    }
    
    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) {
        if height < DBMaxHeightReply {
            let h = height <= 33 ? 33 : height
            self.editorHeight.constant = CGFloat(h)
            print("heightDidChange: \(h)")
        } else if height > DBMaxHeightReply {
            self.editorHeight.constant = CGFloat(DBMaxHeightReply)
        }
    }
    
    func richEditorTookFocus(_ editor: RichEditorView) {
        self.replyView.isHidden = false
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
        self.replyView.isHidden = true
    }
}
