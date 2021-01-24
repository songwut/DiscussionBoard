//
//  PopupEditViewController.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 24/1/2564 BE.
//

import UIKit

class PopupEditViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var didConfirm:DidAction?
    var currentVC: UIViewController!
    
    var isDelete = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.closeButton.setImage(UIImage(named: "ic_v2_close"), for: .normal)
        self.closeButton.imageView?.setTintWith(color: grayColor)
        self.cancelButton.titleFont = .font(.paragraph, .bold)
        self.cancelButton.setTitle("cancel".localized(), for: .normal)
        self.cancelButton.setTitleColor(UIColor(hex: "222831"), for: .normal)
        self.confirmButton.titleFont = .font(.paragraph, .bold)
        self.confirmButton.setTitle("confirm".localized(), for: .normal)
        
        self.confirmButton.setTitleColor(.white, for: .normal)
        self.titleLabel.font = .font(.heading4, .bold)
        self.descTextView.font = .font(.paragraph, .text)
        
        var str = "edit".localized()
        if self.isDelete {
            str = "delete".localized()
            
            self.titleLabel.text = "Delete discussion"
            self.descTextView.text = "Are you sure to delete this discussion?"
        } else {
            self.titleLabel.text = "Edit Discussion"
            self.descTextView.text = "Are you sure to edit this discussion?"
        }
        self.confirmButton.setTitle(str, for: .normal)
        self.confirmButton.setTitleColor(.white, for: .normal)
        self.confirmButton.backgroundColor = .primary()
        //Delete discussion
        //Are you sure to delete this discussion?
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmButtonPressed(_ sender: Any) {
        self.didConfirm?.handler(sender)
        self.dismiss(animated: true, completion: nil)
    }
}
