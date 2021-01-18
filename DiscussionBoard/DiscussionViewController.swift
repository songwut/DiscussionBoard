//
//  DiscussionViewController.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 15/1/2564 BE.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DiscussionViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    weak var postVC:DiscussionPostViewController!

    var postView: UIView!
    private let disposeBag = DisposeBag()
    private let viewModel = DiscussionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.postVC.didPost = DidAction(handler: { (sender) in
            if let html = sender as? String {
                self.viewModel.post(html: html) { (post) in
                    self.reloadDirect()
                }
            }
        })
        self.tableView?.tableHeaderView = self.postView
        self.viewModel.prepareData {
            self.tableView.reloadData()
        }
    }
    
    func reloadDirect() {
        UIView.performWithoutAnimation {
            let loc = self.tableView.contentOffset
            tableView.reloadData()
            tableView.contentOffset = loc
        }
    }
    
    func createPostView() -> UIView {
        self.postVC = (UIStoryboard(name: "Discussion", bundle: nil).instantiateViewController(withIdentifier: "DiscussionPostViewController") as! DiscussionPostViewController)
        self.addChild(self.postVC)
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
        self.viewModel.postList[section].replyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReply") as! ReplyTableViewCell
        cell.reply = self.viewModel.postList[indexPath.section].replyList[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let post = self.viewModel.postList[section]
        
        if section == 0 {
            let pin = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellPostPin") as! PostPinHeaderView
            pin.post = post
            pin.replyAuthor = post.author
            pin.didReload = DidAction(handler: { (sender) in
                self.viewModel.replyList(post: post) { (replyList) in
                    self.reloadDirect()
                }
            })
            return pin
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellPost") as! PostHeaderView
            header.post = post
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
        //let post = self.viewModel.postList[section]
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellFooterReply") as! PostFooterView
        //header.post = post
        return footer
    }
    
}

