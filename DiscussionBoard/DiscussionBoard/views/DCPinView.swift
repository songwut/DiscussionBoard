//
//  DCPinView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit
import RichEditorView

class DCPinView: DCPostView {
    
    override class func instanciateFromNib() -> DCPinView {
        return Bundle.main.loadNibNamed("DCPinView", owner: nil, options: nil)![0] as! DCPinView
    }
    
    @IBOutlet weak var pinImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.seeMoreReplyButton.isHidden = true
        self.authorNameLabel.font = FontHelper.getFontSystem(.small , font: .medium)
        self.textView.font = textViewFont
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:))))
    }

}
