//
//  DCReactionView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 24/1/2564 BE.
//

import UIKit

class DCReactionView: UIView {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var editStackView: UIStackView!
    
    let gray = UIColor(hex: "8F9295")
    var didLikePressed: DidAction?
    var didReplyPressed: DidAction?
    var didEditingPressed: DidAction?
    var content:Any?
    
    func reaction(_ isLiked: Bool, _ countLikes:Int) {
        let numText = countLikes.shorted()
        let unit = countLikes.textNumber(many: "like_unit").split(separator: Character(" "))
        let likeText = numText + " \(unit[1])"
        
        if countLikes == 0 {
            self.likeButton.setTitle("like".localized(), for: .normal)
        } else {
            self.likeButton.setTitle(likeText, for: .normal)
        }
        
        if isLiked {
            self.likeButton.tintColor = .primary()
            self.likeButton.setTitleColor(.primary(), for: .normal)
        } else {
            self.likeButton.tintColor = self.gray
            self.likeButton.setTitleColor(self.gray, for: .normal)
        }
    }
    
    func updateEditContent() {
        
    }
    
    func prepareUI() {
        self.dateLabel.font = .font(.small, .text)
        self.replyButton.titleFont = .font(.small, .bold)
        self.likeButton.titleFont = .font(.small, .bold)
        self.replyButton.backgroundColor = .clear
        self.replyButton.addTarget(self, action: #selector(self.replyPressed(_:)), for: .touchUpInside)
        self.likeButton.addTarget(self, action: #selector(self.replyPressed(_:)), for: .touchUpInside)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.textViewLongPressed(_:)))
        longPress.minimumPressDuration = 0.3
        longPress.allowableMovement = 15
        self.textView.addGestureRecognizer(longPress)
    }
    
    func updateUIColor(isPin:Bool) {
        self.dateLabel.font = FontHelper.getFontSystem(.small , font: .text)
        self.replyButton.titleFont = FontHelper.getFontSystem(.small , font: .bold)
        
        self.dateLabel.textColor = self.gray
        self.replyButton.setTitleColor(self.gray, for: .normal)
        self.likeButton.tintColor = self.gray
    }
    
    @objc func textViewLongPressed(_ sender: UIButton) {
        self.didEditingPressed?.handler(self.content)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        self.didLikePressed?.handler(self.content)
    }
    
    @IBAction  func replyPressed(_ sender: UIButton) {
        self.didReplyPressed?.handler(self.content)
    }
}
