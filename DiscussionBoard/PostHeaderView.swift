//
//  PostHeaderView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import UIKit

class PostHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    
    var post: DiscussionPostResult? {
        didSet {
            if let post = self.post {
                //if let author = post.author
                //self.authorImageView.setim
                self.textView.attributedText = post.body.html2AttributedString
                
            }
        }
    }
    
    class func instanciateFromNib() -> PostHeaderView {
        return Bundle.main.loadNibNamed("PostHeaderView", owner: nil, options: nil)![0] as! PostHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.authorNameLabel.font = FontHelper.getFontSystem(.small , font: .medium)
        self.textView.font = FontHelper.getFontSystem(.small, font: .text)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:))))
    }
    
    @IBAction func seeMoreReplyPressed(_ sender: UIButton) {
        
    }

    @objc func tapIconHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        //delegate?.tapSection(self, content: self.content)
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? PostHeaderView else {
            return
        }
        
        //delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //arrowImageView.rotate(collapsed ? 0.0 : .pi)
    }
    
}
