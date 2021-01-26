//
//  DiscussionPostViewController.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import UIKit
import RichEditorView

enum DiscussionMenuType: String {
    case latest = "latest_discussion"
    case top = "top_discussion"
    
    func value() -> String {
        switch self {
        case .top:
            return "count_likes"
        default:
            return "datetime_create"
        }
    }
}

class DiscussionMenuButton: UIButton {
    var type:DiscussionMenuType = DiscussionMenuType.latest
}

class DiscussionPostViewController: UIViewController {
    
    var viewModel: DiscussionViewModel?

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var selectFilterView: UIView!
    @IBOutlet var currentButton: DiscussionMenuButton!
    @IBOutlet var latestButton: DiscussionMenuButton!
    @IBOutlet var topButton: DiscussionMenuButton!
    
    @IBOutlet var editorBorderView: UIView!
    @IBOutlet var uiStackView: UIStackView!
    @IBOutlet var editorView: RichEditorView!
    @IBOutlet var editorToolStackView: UIStackView!
    @IBOutlet var editorToolView: UIView!
    @IBOutlet var editorToolView2: UIView!
    @IBOutlet var postButton: UIButton!
    
    @IBOutlet weak var limitLabel: UILabel!
    let limitCount = 4000
    
    @IBOutlet var boldButton: UIButton!
    @IBOutlet var italicButton: UIButton!
    @IBOutlet var underlineButton: UIButton!
    @IBOutlet var bulletButton: UIButton!
    @IBOutlet var numberButton: UIButton!
    
    var htmlContent: String?
    var didLoaded: DidAction?
    var didPost: DidAction?
    var didMenuSelected: DidAction?
    
    var menuList = [DiscussionMenuButton]()
    let gray = UIColor(hex: "8F9295")
    
    lazy var editorToolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        //toolbar.options = RichEditorDefaultOption.all
        toolbar.options = [RichEditorDefaultOption.bold, RichEditorDefaultOption.italic, RichEditorDefaultOption.underline]
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiStackView.updateLayout()
        self.imageView.circle()
        let profileImage = self.viewModel?.myProfile()?.image ?? ""
        self.imageView.setImage(profileImage, placeholderImage: nil)
        self.postButton.setStyleColor(false, titleColor: .white, bgColor: .lightGray)
        
        self.editorToolView.layer.borderWidth = 1
        self.editorToolView.layer.borderColor = self.gray.cgColor
        self.editorToolView.layer.cornerRadius = 4
        self.editorToolView.clipsToBounds = true
        
        self.editorToolView2.layer.borderWidth = 1
        self.editorToolView2.layer.borderColor = self.gray.cgColor
        self.editorToolView2.layer.cornerRadius = 4
        self.editorToolView2.clipsToBounds = true
        
        self.editorView.delegate = self
        
        self.boldButton.imageView?.tintColor = .black
        self.italicButton.imageView?.tintColor = .black
        self.underlineButton.imageView?.tintColor = .black
        self.bulletButton.imageView?.tintColor = .black
        self.numberButton.imageView?.tintColor = .black
        self.boldButton.addTarget(self, action: #selector(self.boldPressed(_:)), for: .touchUpInside)
        self.italicButton.addTarget(self, action: #selector(self.italicPressed(_:)), for: .touchUpInside)
        self.underlineButton.addTarget(self, action: #selector(self.underlinePressed(_:)), for: .touchUpInside)
        self.bulletButton.addTarget(self, action: #selector(self.bulletPressed(_:)), for: .touchUpInside)
        self.numberButton.addTarget(self, action: #selector(self.numberPressed(_:)), for: .touchUpInside)
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
        
        self.manageMenuButton()
        
        // custom action that clears all the input text when it is pressed
        /*
        let clear = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }
        */
        self.didLoaded?.handler(self)
    }
    
    func manageMenuButton() {
        self.latestButton.type = .latest
        self.topButton.type = .top
        self.menuList = [self.latestButton, self.topButton]
        
        self.currentButton.type = self.latestButton.type
        self.currentButton.setTitle(self.latestButton.type.rawValue.localized(), for: .normal)
        self.currentButton.addTarget(self, action: #selector(self.currentButtonPressed(_:)), for: .touchUpInside)
        
        for btn in self.menuList {
            btn.isHidden = true
            btn.cornerRadius = 4.0
            btn.borderWidth = 1.0
            btn.borderColor = UIColor(hex: "D7D8D9")
            btn.setTitle(btn.type.rawValue.localized(), for: .normal)
            btn.addTarget(self, action: #selector(self.menuButtonPressed(_:)), for: .touchUpInside)
            btn.setShadow(radius: 5.0, opacity: 0.2, color: .black, offset: CGSize.zero)
        }
    }
    
    @objc func menuButtonPressed(_ button: DiscussionMenuButton) {
        self.selectFilterView.isHidden = true
        self.currentButton.type = button.type
        self.currentButton.setTitle(button.type.rawValue.localized(), for: .normal)
        self.didMenuSelected?.handler(button.type)
    }
    
    @objc func currentButtonPressed(_ button: DiscussionMenuButton) {
        for btn in self.menuList {//hide same type
            btn.isHidden = btn.type == button.type
        }
        self.selectFilterView.isHidden = !self.selectFilterView.isHidden
    }
    
    func updateUI() {
        if let postList = self.viewModel?.postList {
            var text = "discussion".localized()
            if postList.count >= 1 {
                text = text + " " + "(\(postList.count))"
            }
            self.titleLabel.text = text
        }
    }
    
    func resetStyle(_ sender: UIButton) {
        sender.isSelected = false
        sender.backgroundColor = .white
        sender.imageView?.tintColor = .black
    }
    
    func updateSelected(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = .white
            sender.imageView?.tintColor = .black
            
        } else {
            sender.isSelected = true
            sender.backgroundColor = self.gray
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
    
    @objc
    func bulletPressed(_ sender: UIButton) {
        self.editorToolbar.editor?.unorderedList()
        self.updateSelected(sender)
    }
    
    @objc
    func numberPressed(_ sender: UIButton) {
        self.editorToolbar.editor?.orderedList()
        self.updateSelected(sender)
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
        if let textHtml = self.htmlContent {
            print("textHtml:")
            print(textHtml)
        }
        
        self.resetStyle(self.boldButton)
        self.resetStyle(self.italicButton)
        self.resetStyle(self.underlineButton)
        self.resetStyle(self.bulletButton)
        self.resetStyle(self.numberButton)
        
        self.view.endEditing(true)
        self.postButton.setStyleColor(false, titleColor: .white, bgColor: .lightGray)
        self.didPost?.handler(self.htmlContent)
        self.editorView.html = ""
    }

}

extension DiscussionPostViewController: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty || self.editorView.html == "<br>" {
            self.htmlContent = nil
            self.postButton.setStyleColor(false, titleColor: .white, bgColor: DCStyle.disable())
            self.editorBorderView.borderColor = DCStyle.editEnd()
        } else {
            self.postButton.setStyleColor(true, titleColor: .white, bgColor: DCStyle.active())
            self.htmlContent = content
            self.editorBorderView.borderColor = DCStyle.editStart()
        }
        
        DispatchQueue.main.async {
            let text = editor.html.removeHtml
            self.limitLabel.text = "\(text.count)/\(self.limitCount)"
            if text.count > self.limitCount {
                self.postButton.setStyleColor(false, titleColor: .white, bgColor: DCStyle.disable())
            }
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
