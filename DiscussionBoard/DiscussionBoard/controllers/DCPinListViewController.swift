//
//  DCPinListViewController.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 20/1/2564 BE.
//

import UIKit
import RxSwift

class DCPinListViewController: UIViewController {
    
    @IBOutlet var borderView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var contentHeight: NSLayoutConstraint!
    
    var viewModel:DiscussionViewModel!
    var post: DiscussionPostResult!
    
    var isReplyLoaded = false
    var didUpdateLayout: DidAction?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.borderView.borderWidth = 1.0
        self.borderView.cornerRadius = 4
        self.borderView.backgroundColor = .primary_10()
        self.borderView.borderColor = .primary()
        self.hideKeyboardWhenTappedAround()
        self.tableView.register(UINib(nibName: "PostPinHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellPostPin")
        self.tableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "cellReply")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 10.0
        self.tableView.estimatedRowHeight = 10.0
        self.tableView.separatorStyle = .none
        self.tableView.remembersLastFocusedIndexPath = true
        self.tableView.isScrollEnabled = false
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView.rx.setDataSource(self).disposed(by: disposeBag)
        
    }
    
    func reloadUI() {
        self.tableView.reloadData()
    }
    
    func reloadDirect(complete: () -> ()) {
        UIView.performWithoutAnimation {
            let ofset = tableView.contentOffset
            tableView.reloadData()
            tableView.contentOffset = ofset
            complete()
        }
    }
    
    func bindTableView() {
        self.tableView.register(UINib(nibName: "PostHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellPost")
        self.tableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "cellReply")
        
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

extension DCPinListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let replyCount = self.viewModel.postList[section].replyList.count
        if self.isReplyLoaded , replyCount > 2 {
            return replyCount
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReply") as! ReplyTableViewCell
        let post = self.viewModel.postList[indexPath.section]
        cell.isPostPin = true
        cell.reply = post.replyList[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let post = self.viewModel.postList[section]
        
        let pin = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellPostPin") as! PostPinHeaderView
        pin.post = post
        pin.replyAuthor = post.author
        //pin.didUpdateLayout = self.didUpdateLayout
        pin.didLoadReply = DidAction(handler: { (sender) in
            self.isReplyLoaded = true
        })
        pin.updateReplyUI(post: post)
        pin.didReply = DidAction(handler: { (sender) in
            guard let html = sender as? String else { return }
            self.viewModel.reply(html: html, post: post) { (reply) in
                self.reloadDirect {
                    self.didUpdateLayout?.handler(post)
                }
            }
        })
        pin.didReload = DidAction(handler: { (sender) in
            self.viewModel.replyList(post: post) { (replyList) in
                self.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {//start
                    print("pin height: \(self.tableView.contentSize.height)")
                    self.contentHeight.constant = self.tableView.contentSize.height
                    self.didUpdateLayout?.handler(post)
                }
            }
        })
        return pin
        
    }
}
