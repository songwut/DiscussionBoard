//
//  DCEditView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 24/1/2564 BE.
//

import UIKit
import RichEditorView

class DCEditView: UIView {

    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editorView: RichEditorView!
    @IBOutlet weak var editorHeight: NSLayoutConstraint!
    
    var didEdited: DidAction?
    
    class func instanciateFromNib() -> DCEditView {
        return Bundle.main.loadNibNamed("DCEditView", owner: nil, options: nil)![0] as! DCEditView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editorView.delegate = self
        self.editButton.isHidden = true
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        self.didEdited?.handler(self.editorView.html)
        self.editorView.html = ""
        self.isHidden = true
    }
    
    @IBAction func canclePressed(_ sender: UIButton) {
        self.isHidden = true
    }
}


extension DCEditView: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty || self.editorView.html == "<br>" {
            self.editButton.setStyleColor(false, titleColor: .white, bgColor: DCStyle.disable())
            editor.superview?.borderColor = DCStyle.editEnd()
        } else {
            self.editButton.setStyleColor(true, titleColor: .white, bgColor: DCStyle.active())
            editor.superview?.borderColor = DCStyle.editStart()
        }
    }
    
    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) {
        if height < DBMaxHeightReply {
            let h = height <= 33 ? 33 : height
            self.editorHeight.constant = CGFloat(h)
            print("heightDidChange: \(h)")
        }
    }
    
    func richEditorTookFocus(_ editor: RichEditorView) {
        self.editButton.isHidden = false
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
        self.editButton.isHidden = true
    }
}
