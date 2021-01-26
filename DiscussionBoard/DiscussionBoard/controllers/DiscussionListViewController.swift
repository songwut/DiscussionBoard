//
//  DiscussionListViewController.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 21/1/2564 BE.
//

import UIKit

class PostObj {
    var postView: DCPostView?
    var replyList = [DCReplyView]()
}

class DiscussionListViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var postCreateStackView: UIStackView!
    @IBOutlet weak var pinStackView: UIStackView!
    @IBOutlet weak var pinItemStackView: UIStackView!
    @IBOutlet weak var postItemStackView: UIStackView!
    
    @IBOutlet weak var pinBorderView: UIView!
    
    private let viewModel = DiscussionViewModel()
    
    weak var postVC:DiscussionPostViewController!
    
    var editingView:DCEditView!
    var pinView: DCPinView!
    var latestEditditingView:
    DCReactionView?
    var postViewList = [Int: PostObj]()
    var isSaveOfset = true
    var tableViewOfset:CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = .white
        self.editingView = DCEditView.instanciateFromNib()
        self.editingView.didEdited = DidAction(handler: { (sender) in
            if let html = sender as? String {
                let item = self.latestEditditingView?.content
                self.viewModel.edit(html: html, item: item) { (content) in
                    //update only item UI
                    if let postView = self.latestEditditingView as? DCPostView {
                        postView.updateEditContent()
                        
                    } else if let pinView = self.latestEditditingView as? DCPinView {
                        pinView.updateEditContent()
                        
                    } else if let replyView = self.latestEditditingView as? DCReplyView {
                        replyView.updateEditContent()
                    }
                    
                }
            }
        })
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
            
            self.pinBorderView.backgroundColor = .primary_10()
            self.pinStackView.removeAllArrangedSubviews()
            self.pinView = DCPinView.instanciateFromNib()
            let pinPost = self.viewModel.postList[pinIndex]
            self.pinView.post = pinPost
            self.pinView.updateReplyUI(post: pinPost)
            self.pinView.didLikePressed = DidAction(handler: { (sender) in
                self.reaction(content: pinPost, reactionView: self.pinView)
            })
            self.pinView.didReplyPressed = DidAction(handler: { (sender) in
                if self.pinView.addReplyView == nil {
                    let addReplyView = self.createAddReplyViewForPin(postView: self.pinView)
                    addReplyView.post = self.pinView.post
                    self.pinView.addReplyView = addReplyView
                    self.pinView.addReplyStackView.addArrangedSubview(addReplyView)
                }
            })
            self.pinView.didSeeMoreReply = DidAction(handler: { (sender) in
                self.viewModel.replyList(post: pinPost) { (replyList) in
                    //reply full
                    if let postObj = self.postViewList[pinPost.id] {
                        self.pinView.itemStackView.removeAllArranged()
                        for reply in replyList {
                            self.createReplyView(postView:self.pinView, reply: reply, postObj: postObj)
                        }
                    }
                }
            })
            self.pinView.didEditingPressed = DidAction(handler: { (sender) in
                self.showAlertEditing(self.pinView,isEditable: pinPost.isEditable, vc: self)
            })
            
            self.pinStackView.isHidden = false
            self.pinStackView.addArrangedSubview(self.pinView)
            
            //pin item
            self.pinItemStackView.removeAllArrangedSubviews()
            var index = 0
            let postObj = PostObj()
            postObj.postView = self.pinView
            self.pinView.itemStackView.removeAllArranged()
            for reply in self.viewModel.postList[pinIndex].replyList {
                if index < 2 {
                    self.createReplyView(postView:self.pinView, reply: reply, postObj: postObj)
                    index += 1
                }
            }
            self.postViewList[pinPost.id] = postObj
        } else {
            self.pinStackView.isHidden = true
        }
        
        //post item
        var postIndex = 0
        self.postItemStackView.removeAllArrangedSubviews()
        for post in self.viewModel.postList {
            let postView = DCPostView.instanciateFromNib()
            postView.post = post
            postView.index = postIndex
            postView.updateReplyUI(post: post)
            
            postView.didLikePressed = DidAction(handler: { (sender) in
                self.reaction(content: post, reactionView: postView)
            })
            postView.didReplyPressed = DidAction(handler: { (sender) in
                if postView.addReplyView == nil {
                    let addReplyView = self.createAddReplyView(postView: postView)
                    addReplyView.post = postView.post
                    postView.addReplyView = addReplyView
                    postView.addReplyStackView.addArrangedSubview(addReplyView)
                }
            })
            postView.didSeeMoreReply = DidAction(handler: { (sender) in
                self.viewModel.replyList(post: post) { (replyList) in
                    //reply full
                    if let postObj = self.postViewList[post.id] {
                        postView.itemStackView.removeAllArranged()
                        for reply in replyList {
                            self.createReplyView(postView:postView, reply: reply, postObj: postObj)
                        }
                    }
                }
            })
            postView.didEditingPressed = DidAction(handler: { (sender) in
                self.showAlertEditing(postView,isEditable: post.isEditable, vc: self)
            })
            
            //reply item
            postView.itemStackView.removeAllArrangedSubviews()
            var index = 0
            let postObj = PostObj()
            postObj.postView = postView
            postView.itemStackView.removeAllArranged()
            for reply in post.replyList {
                if index < 2 {
                    //create reply
                    self.createReplyView(postView:postView, reply: reply, postObj: postObj)
                    index += 1
                }
            }
            self.postViewList[post.id] = postObj
            self.postItemStackView.addArrangedSubview(postView)
            
            postIndex += 1
        }
    }
    
    func createPost(post:DiscussionPostResult) {
        let postView = DCPostView.instanciateFromNib()
        postView.post = post
        postView.updateReplyUI(post: post)
        
        postView.didLikePressed = DidAction(handler: { (sender) in
            self.reaction(content: post, reactionView: postView)
        })
        postView.didReplyPressed = DidAction(handler: { (sender) in
            if postView.addReplyView == nil {
                let addReplyView = self.createAddReplyView(postView: postView)
                addReplyView.post = postView.post
                postView.addReplyView = addReplyView
                postView.addReplyStackView.addArrangedSubview(addReplyView)
            }
        })
        postView.didSeeMoreReply = DidAction(handler: { (sender) in
            self.viewModel.replyList(post: post) { (replyList) in
                //reply full
                if let postObj = self.postViewList[post.id] {
                    postView.itemStackView.removeAllArranged()
                    for reply in replyList {
                        self.createReplyView(postView:postView, reply: reply, postObj: postObj)
                    }
                }
            }
        })
        postView.didEditingPressed = DidAction(handler: { (sender) in
            self.showAlertEditing(postView,isEditable: post.isEditable, vc: self)
        })
        
        //reply item
        postView.itemStackView.removeAllArrangedSubviews()
        let postObj = PostObj()
        postObj.postView = postView
        postView.itemStackView.removeAllArranged()
        self.postViewList[post.id] = postObj
        self.postItemStackView.insertArrangedSubview(postView, at: 0)
        
        self.postScrolling(postObj)
    }
    
    func postScrolling(_ postObj:PostObj) {
        self.postItemStackView.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let topY = self.postItemStackView.frame.origin.y
            let navH = self.navigationController?.navigationBar.frame.height ?? 0.0
            let point = CGPoint(x: 0, y: topY - navH)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.scrollView.contentOffset = point
            } completion: { (done) in
                
            }
        }
    }
    
    func createReplyView(postView:DCPostView ,reply: DiscussionReplyResult, postObj:PostObj) {
        let replyView = self.createReply(reply)
        postObj.replyList.append(replyView)
        postView.itemStackView.addArrangedSubview(replyView)
        replyView.didReplyPressed = DidAction(handler: { (sender) in
            if postView.addReplyView == nil {
                let addReplyView = self.createAddReplyView(postView: postView)
                addReplyView.post = postView.post
                postView.addReplyView = addReplyView
                postView.addReplyStackView.addArrangedSubview(addReplyView)
            }
            self.focusEditor(addReplyView: postView.addReplyView)
            
        })
    }
    
    func focusEditor(addReplyView:DCAddReplyView?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {//start
            let _ = addReplyView?.editorView.becomeFirstResponder()
        }
    }
    
    func createAddReplyViewForPin(postView: DCPostView) -> DCAddReplyView {
        let addReplyView = DCAddReplyView.instanciateFromNib()
        addReplyView.profile = self.viewModel.myProfile()
        addReplyView.didReply = DidAction(handler: { (sender) in
            self.view.endEditing(true)
            guard let html = sender as? String,
                  let post = self.pinView.post,
                  let postObj = self.postViewList[post.id] else { return }
            self.viewModel.reply(html: html, post: post) { (reply) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {//start
                    self.createReplyView(postView:postView, reply: reply, postObj: postObj)
                    //TODO: Scroll up
                }
            }
        })
        return addReplyView
    }
    
    func createAddReplyView(postView: DCPostView) -> DCAddReplyView {
        let addReplyView = DCAddReplyView.instanciateFromNib()
        addReplyView.profile = self.viewModel.myProfile()
        addReplyView.didReply = DidAction(handler: { (sender) in
            self.view.endEditing(true)
            guard let html = sender as? String,
                  let post = addReplyView.post,
                  let postObj = self.postViewList[post.id] else { return }
            self.viewModel.reply(html: html, post: post) { (reply) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {//start
                    self.createReplyView(postView:postView, reply: reply, postObj: postObj)
                    //TODO: Scroll up
                }
            }
        })
        return addReplyView
    }
    
    func createReply(_ reply:DiscussionReplyResult) -> DCReplyView {
        let replyView = DCReplyView.instanciateFromNib()
        replyView.didLikePressed = DidAction(handler: { (sender) in
            self.reaction(content: reply, reactionView: replyView)
        })
        replyView.reply = reply
        replyView.didEditingPressed = DidAction(handler: { (sender) in
            self.showAlertEditing(replyView,isEditable: reply.isEditable, vc: self)
        })
        return replyView
    }
    
    func reaction(content:Any, reactionView:DCReactionView) {
        self.viewModel.reaction(item: content) { (result, isLiked) in
            if let reaction = result,
               let countLikes = reaction.countLikes {
                reactionView.reaction(isLiked, countLikes)
            }
        }
    }
    
    
    func createPostView() {
        if self.postVC == nil {
            self.postVC = (UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "DiscussionPostViewController") as! DiscussionPostViewController)
            self.addChild(self.postVC)
            self.postVC.viewModel = self.viewModel
            self.postVC.view.frame = CGRect(x: 0, y: 0,width: self.view.bounds.width, height: self.view.bounds.height)
            self.postVC.didMove(toParent: self)
        }
        
        self.postVC.didMenuSelected = DidAction(handler: { (sender) in
            if let type = sender as? DiscussionMenuType {
                self.viewModel.currentMenu = type
                //TODO: API
                self.viewModel.prepareData {
                    self.updateUI()
                    
                }
            }
        })
        self.postVC.didPost = DidAction(handler: { (sender) in
            if let html = sender as? String {
                self.viewModel.post(html: html) { (post) in
                    self.postVC.updateUI()
                    self.createPost(post: post)
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isSaveOfset {
            self.tableViewOfset = self.scrollView.contentOffset
            print("scrollViewY :\(scrollView.contentOffset.y)")
        }
    }
    
    func showAlertEditing(_ targetView:DCReactionView ,isEditable: Bool, vc: UIViewController) {
        if isEditable {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.view.tintColor = UIColor.black
            let editAction = UIAlertAction(title: "edit".localized() , style: .default) { (action) in
                self.popupWarning(isDelete: false, vc: vc) { (isConfirm) in
                    if isConfirm {
                        self.editingView.isHidden = false
                        self.latestEditditingView = targetView
                        targetView.editStackView.addArrangedSubview(self.editingView)
                    }
                }
            }
            let deleteAction = UIAlertAction(title: "delete".localized() , style: .destructive) { (action) in
                //check can delete
                self.popupWarning(isDelete: true, vc: vc) { (isConfirm) in
                    if isConfirm {
                        targetView.removeFromSuperview()
                        self.latestEditditingView = targetView
                        self.viewModel.delete(view: targetView) { (done) in
                            //done delete
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "cancel".localized() , style: .cancel) { (action) in
                self.view.endEditing(true)
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(editAction)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = self.view.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func popupWarning(isDelete:Bool = false, vc: UIViewController, complete: @escaping(_ isConfirm:Bool) -> ()) {
        let popVC = (UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "PopupEditViewController") as! PopupEditViewController)
        popVC.isDelete = isDelete
        popVC.didConfirm = DidAction(handler: { (sender) in
            complete(true)
        })
        popVC.modalTransitionStyle = .crossDissolve
        popVC.modalPresentationStyle = .overFullScreen
        vc.present(popVC, animated: true) {
            
        }
    }

}
