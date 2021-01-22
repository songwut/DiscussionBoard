//
//  EditorHelper.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit
import RichEditorView

class EditorHelper: NSObject {
    
    var borderView: UIView!

    var editView: UIView!
    var editButton: UIButton!
    var cancelButton: UIButton!
    var editorView: RichEditorView!
    var editorHeight: NSLayoutConstraint!
    
    var isFocus = false {
        didSet {
            self.borderView.borderColor = self.isFocus ? .primary() : .clear
            self.borderView.borderWidth = self.isFocus ? 1.0 : 0.0
            self.borderView.cornerRadius = 4.0
        }
    }
    
    override init() {
        super.init()
        
    }
}

extension EditorHelper: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) {
        if height < DBMaxHeightReply {
            let h = height <= 33 ? 33 : height
            self.editorHeight.constant = CGFloat(h)
            //self.didUpdateLayout?.handler(CGFloat(h))
            print("heightDidChange: \(h)")
        }
    }
    
    func richEditorTookFocus(_ editor: RichEditorView) {
        self.isFocus = true
        
        //self.replyView.isHidden = false
        //self.didUpdateLayout?.handler(self)
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
        self.isFocus = true
        //self.replyView.isHidden = true
        //self.didUpdateLayout?.handler(self)
    }
}
