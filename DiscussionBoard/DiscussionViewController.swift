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

    private let disposeBag = DisposeBag()
    private let viewModel = DiscussionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "PostHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "cellPost")
        self.tableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "cellReply")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 10.0
        self.tableView.estimatedRowHeight = 10.0
        self.tableView.separatorStyle = .none
        self.tableView?.tableHeaderView = self.postHeader()
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView.rx.setDataSource(self).disposed(by: disposeBag)
        self.viewModel.prepareData {
            self.tableView.reloadData()
        }
    }
    
    func postHeader() -> UIView {
        //add child DiscussionPostViewController
        return UIView()
        
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
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cellPost") as! PostHeaderView
        header.post = post
        //header.setCollapsed(post.collapsed)
        //header.section = section
        //header.delegate = self
        return header
    }
    
}

