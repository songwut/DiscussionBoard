//
//  DiscussionListViewController.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit

class DiscussionListViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var postCreateStackView: UIStackView!
    @IBOutlet weak var pinStackView: UIStackView!
    @IBOutlet weak var pinItemStackView: UIStackView!
    @IBOutlet weak var postItemStackView: UIStackView!
    
    @IBOutlet weak var pinBorderView: UIView!
    
    private let viewModel = DiscussionViewModel()
    
    weak var postVC:DiscussionPostViewController!
    var pinVC:DCPinListViewController!
    
    var pinView: DCBasePostView!
    var postViewList = [Int: UIView]()
    var isSaveOfset = true
    var tableViewOfset:CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewmodelCallApi()
    }
    
    func viewmodelCallApi() {
        self.viewModel.prepareData {
            self.updateUI()
            
        }
    }
    
    func updateUI() {
        
        //editor
        self.postCreateStackView.removeAllArrangedSubviews()
        self.createPostView()
        self.postVC.updateUI()
        self.postCreateStackView.addArrangedSubview(self.postVC.view)
        
        //pin
        if let pinIndex = self.viewModel.pinIndex {
            
            /*
            self.createPinView()
            self.pinStackView.addArrangedSubview(self.pinVC.tableView)
            self.pinVC.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let height = self.pinVC.tableView.contentSize.height
                self.pinVC.view.frame = CGRect(x: 0, y: 0,width: self.view.bounds.width, height: height)
                
            }
            */
            self.pinBorderView.backgroundColor = .primary_10()
            self.pinStackView.removeAllArrangedSubviews()
            self.pinView = DCPinView.instanciateFromNib()
            self.pinView.post = self.viewModel.postList[pinIndex]
            self.pinStackView.isHidden = false
            self.pinStackView.addArrangedSubview(self.pinView)
            
            
            //post
            var index = 0
            for reply in self.viewModel.postList[pinIndex].replyList {
                if index < 2 {
                    let replyView = DCReplyView.instanciateFromNib()
                    replyView.reply = reply
                    self.pinItemStackView.addArrangedSubview(replyView)
                    index += 1
                }
            }
            
            
        } else {
            self.pinStackView.isHidden = true
        }
        
        //post item
        self.postItemStackView.removeAllArrangedSubviews()
        for post in self.viewModel.postList {
            let postView = DCPostView.instanciateFromNib()
            postView.post = post
            postView.updateReplyUI(post: post)
            postView.didReload = DidAction(handler: { (sender) in
                self.viewModel.replyList(post: post) { (replyList) in
                    //postView
                    //self.reloadDirect()
                }
            })
            self.postViewList[post.id] = postView
            self.postItemStackView.addArrangedSubview(postView)
        }
    }
    
    
    
    func createPostView() {
        self.postVC = (UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "DiscussionPostViewController") as! DiscussionPostViewController)
        self.addChild(self.postVC)
        self.postVC.viewModel = self.viewModel
        self.postVC.view.frame = CGRect(x: 0, y: 0,width: self.view.bounds.width, height: self.view.bounds.height)
        self.postVC.didMove(toParent: self)
        self.postVC.didMenuSelected = DidAction(handler: { (sender) in
            if let type = sender as? DiscussionMenuType {
                self.viewModel.currentMenu = type
                self.updateUI()
            }
        })
        self.postVC.didPost = DidAction(handler: { (sender) in
            if let html = sender as? String {
                self.viewModel.post(html: html) { (post) in
                    self.postVC.updateUI()
                }
            }
        })
        DispatchQueue.main.async {
            let height = self.postVC.uiStackView.bounds.height
            self.postVC.view.frame = CGRect(x: 0, y: 0,width: self.view.bounds.width, height: height)
            self.postVC.didLoaded = DidAction(handler: { (sender) in
                print("PostUI didLoaded")
            })
        }
    }
    
    func createPinView() {
        self.pinVC = (UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "DCPinListViewController") as! DCPinListViewController)
        self.addChild(self.pinVC)
        self.pinVC.viewModel = self.viewModel
        self.pinVC.view.frame = CGRect(x: 0, y: 0,width: self.view.bounds.width, height: self.view.bounds.height)
        self.pinVC.didMove(toParent: self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isSaveOfset {
            self.tableViewOfset = self.scrollView.contentOffset
            print("scrollViewY :\(scrollView.contentOffset.y)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
