//
//  DiscussionPostViewController.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import UIKit
import RichEditorView

class DiscussionPostViewController: UIViewController {

    @IBOutlet var editorView: RichEditorView!
    @IBOutlet var htmlTextView: UITextView?
    @IBOutlet var editorToolStackView: UIStackView!
    @IBOutlet var editorToolView: UIView!
    
    @IBOutlet var boldButton: UIButton!
    @IBOutlet var italicButton: UIButton!
    @IBOutlet var underlineButton: UIButton!
    
    
    lazy var editorToolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        //toolbar.options = RichEditorDefaultOption.all
        toolbar.options = [RichEditorDefaultOption.bold, RichEditorDefaultOption.italic, RichEditorDefaultOption.underline]
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editorToolView.layer.borderWidth = 1
        self.editorToolView.layer.borderColor = grayColor.cgColor
        self.editorToolView.layer.cornerRadius = 4
        self.editorToolView.clipsToBounds = true
        self.editorView.delegate = self
        
        self.boldButton.imageView?.tintColor = .black
        self.italicButton.imageView?.tintColor = .black
        self.underlineButton.imageView?.tintColor = .black
        self.boldButton.addTarget(self, action: #selector(self.boldPressed(_:)), for: .touchUpInside)
        self.italicButton.addTarget(self, action: #selector(self.italicPressed(_:)), for: .touchUpInside)
        self.underlineButton.addTarget(self, action: #selector(self.underlinePressed(_:)), for: .touchUpInside)
        //add editor tool to top keyboard
        //editorView.inputAccessoryView = editorToolbar
        
        //add editor tool to view
        /*
        let heightConstraint = NSLayoutConstraint(item: self.editorToolbar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        self.editorToolbar.addConstraints([heightConstraint])
        self.editorToolStackView.addArrangedSubview(self.editorToolbar)
        */
        self.editorView.placeholder = "Write a comment"

        //connect editorView to tool bar
        self.editorToolbar.delegate = self
        self.editorToolbar.editor = self.editorView

        // custom action that clears all the input text when it is pressed
        /*
        let clear = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }
        */
        
    }
    
    func updateSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.imageView?.tintColor = .black
            
        } else {
            sender.isSelected = true
            sender.backgroundColor = grayColor
            sender.imageView?.tintColor = .black
        }
    }
    
    @objc
    func boldPressed(_ sender: UIButton) {
        self.editorToolbar.editor?.bold()
        self.updateSelected(sender)
    }
    
    @objc
    func italicPressed(_ sender: UIButton) {
        self.editorToolbar.editor?.italic()
        self.updateSelected(sender)
    }
    
    @objc
    func underlinePressed(_ sender: UIButton) {
        self.editorToolbar.editor?.underline()
        self.updateSelected(sender)
    }

}

extension DiscussionPostViewController: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            htmlTextView?.text = "HTML Preview"
        } else {
            htmlTextView?.text = content
        }
    }
    
}

extension DiscussionPostViewController: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }

    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if toolbar.editor?.hasRangeSelection == true {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
}
