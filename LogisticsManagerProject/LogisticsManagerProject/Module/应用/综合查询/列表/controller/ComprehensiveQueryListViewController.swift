//
//  ComprehensiveQueryListViewController.swift
//  LogisticsManagerProject
//
//  Created by 王岩 on 2018/11/11.
//  Copyright © 2018年 王岩. All rights reserved.
//

import UIKit
import ObjectMapper
import ESPullToRefresh
class ComprehensiveQueryListViewController: BaseViewController {

    @IBOutlet weak var noDataLabel: UILabel!
    var dataController:ComprehensiveQueryListDataController!
    @IBOutlet weak var tableView: UITableView!
    var pageIndex = 1
    var filterModel = FilterModel()
    var infoJson = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        initUI()
        comprehensiveQueryList(loadType: .first)
        
    }
}
extension ComprehensiveQueryListViewController{
    fileprivate func initData(){
        dataController = ComprehensiveQueryListDataController(delegate: self)
        
    }
    
    fileprivate func initUI(){
        self.view.backgroundColor = UIColor(hexString: "F0F0F0")
        self.edgesForExtendedLayout = .top
        loadRightBarButtonItem()
        initTableView()
    }
    
    fileprivate func initTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.backgroundColor = UIColor.clear
        tableView.register("ComprehensiveQueryListTableViewCell")
        let animator = ESRefreshHeaderAnimator()
        animator.pullToRefreshDescription = "下拉刷新"
        animator.releaseToRefreshDescription = "松开刷新"
        animator.loadingDescription = "加载中..."
        
        self.tableView.es.addPullToRefresh(animator: animator) {
            self.tableView.es.resetNoMoreData()
            self.comprehensiveQueryList(loadType: .top)
        }
        let animator2 = ESRefreshFooterAnimator()
        animator2.noMoreDataDescription = "没有更多的了"
        animator2.loadingMoreDescription = "正在加载更多"
        animator2.loadingDescription = "加载中..."
        
        self.tableView.es.addInfiniteScrolling(animator: animator2) {
            self.pageIndex = self.pageIndex + 1
            self.comprehensiveQueryList(loadType: .down)
        }
    }
    
    /**
     * 加载导航栏右侧按钮
     */
    fileprivate func loadRightBarButtonItem(){
        let button =   UIButton(type: .system)
        button.frame = CGRect(x:0, y:0, width:10, height:30)
        
        button.setTitle("筛选", for: .normal)
        //        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.sizeToFit()
        button.addTarget(self, action: #selector(rightItemClick), for: .touchUpInside)
        let rightBarBtn = UIBarButtonItem(customView: button)
        //用于消除左边空隙，要不然按钮顶不到最前面
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -5;
        self.navigationItem.rightBarButtonItems = [spacer,rightBarBtn]
    }
    
    @objc func rightItemClick(){
        pushViewController("FilterViewController", sender: nil) { (info) in
            if info != nil{
                self.filterModel = info as! FilterModel
                self.comprehensiveQueryList(loadType: .first)
            }
        }
        
        
    }
}
extension ComprehensiveQueryListViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataController.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ComprehensiveQueryListTableViewCell.loadCell(tableView)
        cell.update(model: dataController.dataArray[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushViewController("ComprehensiveQueryDetailViewController",sender:dataController.dataArray[indexPath.row].id)
    }
}
extension ComprehensiveQueryListViewController{
    fileprivate func comprehensiveQueryList(loadType:DirectionType) {
        if loadType == .first || loadType == .top{
            self.dataController.dataArray.removeAll()
            pageIndex = 1
        }
        let parameter:NSMutableDictionary = [
            "pageNo":String(pageIndex),
            "info":filterModel.toJSONString()
        ]
        dataController.shippingList(parameter: parameter) { (isSucceed, result) in
            if self.pageIndex <= self.dataController.lastPage{
                if loadType == .top {
                    self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
                    
                    
                    self.dataController.dataArray.removeAll()
                }else if loadType == .down{
                    self.tableView.es.stopLoadingMore()
                }
                if self.dataController.model.data.count > 0{
                    for item in self.dataController.model.data{
                        self.dataController.dataArray.append(item)
                    }
                }
            }else{
                if loadType == .top {
                    self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
                }else if loadType == .down{
                    //                    self.tableView.es.stopLoadingMore()
                    self.tableView.es.noticeNoMoreData()
                }
            }
            if self.dataController.dataArray.count > 0{
                self.noDataLabel.isHidden = true
            }else{
                self.noDataLabel.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
}
