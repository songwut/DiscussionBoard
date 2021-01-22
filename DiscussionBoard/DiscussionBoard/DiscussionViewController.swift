//
//  DiscussionViewController.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import UIKit
import RxSwift

let DBMaxHeightReply = 224
class DiscussionViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    weak var postVC:DiscussionPostViewController!
    //weak var pinVC:DCPinListViewController!

    var postView: UIView!
    var pinView: UIView!
    private let disposeBag = DisposeBag()
    private let viewModel = DiscussionViewModel()
    
    var isSaveOfset = true
    var tableViewOfset:CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.register(UINib(nibName: "PostPinHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellPostPin")
        self.tableView.register(UINib(nibName: "PostHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellPost")
        self.tableView.register(UINib(nibName: "PostFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellFooterReply")
        
        self.tableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "cellReply")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.sectionFooterHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 10.0
        self.tableView.estimatedSectionFooterHeight = 34.0
        self.tableView.estimatedRowHeight = 10.0
        self.tableView.separatorStyle = .none
        self.tableView.remembersLastFocusedIndexPath = true
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView.rx.setDataSource(self).disposed(by: disposeBag)
        
        self.postView = self.createPostView()
        self.postVC.didMenuSelected = DidAction(handler: { (sender) in
            if let type = sender as? DiscussionMenuType {
                self.viewModel.currentMenu = type
                self.reloadUI()
            }
        })
        self.postVC.didPost = DidAction(handler: { (sender) in
            if let html = sender as? String {
                self.viewModel.post(html: html) { (post) in
                    self.postVC.updateUI()
                    self.reloadDirect()
                }
            }
        })
        self.tableView?.tableHeaderView = self.postView
        
        self.reloadUI()
    }
    
    func reloadUI() {
        self.viewModel.prepareData {
            self.postVC.updateUI()
            
            if let pinIndex = self.viewModel.pinIndex {
                
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    func reloadDirect() {
        self.isSaveOfset = false
        UIView.performWithoutAnimation {
            tableView.reloadData()
            tableView.contentOffset = self.tableViewOfset
            self.isSaveOfset = false
        }
    }
    
    func createPostView() -> UIView {
        self.postVC = (UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "DiscussionPostViewController") as! DiscussionPostViewController)
        self.addChild(self.postVC)
        self.postVC.viewModel = self.viewModel
        self.postVC.view.frame = CGRect(x: 0, y: 0,width: self.view.bounds.width, height: self.view.bounds.height)
        self.postVC.didMove(toParent: self)
        DispatchQueue.main.async {
            let height = self.postVC.uiStackView.bounds.height
            self.postVC.view.frame = CGRect(x: 0, y: 0,width: self.view.bounds.width, height: height)
            self.postVC.didLoaded = DidAction(handler: { (sender) in
                print("PostUI didLoaded")
            })
        }
        return self.postVC.view
    }
    
    func bindTableView() {
        self.tableView.register(UINib(nibName: "PostHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellPost")
        self.tableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "cellReply")
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isSaveOfset {
            self.tableViewOfset = self.tableView.contentOffset
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

extension DiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.postList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = self.viewModel.postList[section]
        if post.isPinned , section == 0 {
            return 0
        } else {
            return post.replyList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = self.viewModel.postList[indexPath.section]
        if post.isPinned , indexPath.section == 0 {
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReply") as! ReplyTableViewCell
        
        cell.reply = post.replyList[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let post = self.viewModel.postList[section]
        
        if post.isPinned, section == 0 {
            //self.pinVC?.contentHeight.constant = self.pinVC?.tableView.contentSize.height ?? 0.0
            
            return nil
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellPost") as! PostHeaderView
            header.post = post
            header.updateReplyUI(post: post)
            header.didReload = DidAction(handler: { (sender) in
                self.viewModel.replyList(post: post) { (replyList) in
                    self.reloadDirect()
                }
            })
            //header.setCollapsed(post.collapsed)
            //header.section = section
            //header.delegate = self
            return header
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.viewModel.pinIndex == section {
            //ignore create reply footer
            return nil
        } else {
            let post = self.viewModel.postList[section]
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellFooterReply") as! PostFooterView
            footer.replyAuthor = post.author
            footer.didReply = DidAction(handler: { (sender) in
                guard let html = sender as? String else { return }
                self.viewModel.reply(html: html, post: post) { (reply) in
                    self.reloadDirect()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {//start
                        let row = post.replyList.count - 1
                        tableView.scrollToRow(at: IndexPath(row: row, section: section), at: .middle, animated: false)
                    }
                }
            })
            footer.didUpdateLayout = DidAction(handler: { (sender) in
                self.reloadDirect()
            })
            //header.post = post
            return footer
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardView(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboardView(_ gesture: UITapGestureRecognizer?) {
        if let tap = gesture, let view = tap.view {
            //view.endEditing(true)
        }
    }
}

