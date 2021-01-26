//
//  LearningTimeView.swift
//  ImproveFilter
//
//  Created by Songwut Maneefun on 26/1/2564 BE.
//

import UIKit

class LearningTimeView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var learningView: UIView!
    @IBOutlet weak var learningImageView: UIImageView!
    @IBOutlet weak var learningLabel: UILabel!
    @IBOutlet weak var learningValueLabel: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stackView.spacing = UIDevice.isIpad() ? 33 : 8
        
        self.learningView.setShadow(radius: 9, opacity: 0.16, color: .black, offset: CGSize(width: 0, height: 2))
        self.timeView.setShadow(radius: 9, opacity: 0.16, color: .black, offset: CGSize(width: 0, height: 2))
        
        self.learningLabel.text = "Learning Hours"
        self.learningValueLabel.text = "46h 32m"
        self.timeLabel.text = "Time Spending"
        self.timeValueLabel.text = "58h 41m"
        
        self.learningImageView.tintColor = .primary()
        self.learningLabel.textColor = .secondary()
        self.learningValueLabel.textColor = .black
        self.learningLabel.font = .font(.xxsmall, .text)
        self.learningValueLabel.font = .font(.heading5, .bold)
        
        self.timeImageView.tintColor = .primary()
        self.timeLabel.textColor = .secondary()
        self.timeValueLabel.textColor = .black
        self.timeLabel.font = .font(.xxsmall, .text)
        self.timeValueLabel.font = .font(.heading5, .bold)
    }

    class func instanciateFromNib() -> LearningTimeView {
        return Bundle.main.loadNibNamed("LearningTimeView", owner: nil, options: nil)![0] as! LearningTimeView
    }
}
