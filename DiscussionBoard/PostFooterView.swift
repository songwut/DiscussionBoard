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
    @IBOutlet var editorView: RichEditorView!
    
    class func instanciateFromNib() -> PostFooterView {
        return Bundle.main.loadNibNamed("PostFooterView", owner: nil, options: nil)![0] as! PostFooterView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.replyView.isHidden = true
    }

}
