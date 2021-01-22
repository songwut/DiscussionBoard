//
//  EditorHelper.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit
import RichEditorView

class EditorHelper: NSObject {

    var editView: UIView!
    var editButton: UIButton!
    var cancelButton: UIButton!
    var editorView: RichEditorView!
    var editorHeight: NSLayoutConstraint!
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
        //self.replyView.isHidden = false
        //self.didUpdateLayout?.handler(self)
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
        //self.replyView.isHidden = true
        //self.didUpdateLayout?.handler(self)
    }
}
