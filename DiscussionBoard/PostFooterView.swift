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
        self.replyView.isHidden = true
        self.replyView.isHidden = true
        self.replyAuthorImageView.setCircle()
    }

}
