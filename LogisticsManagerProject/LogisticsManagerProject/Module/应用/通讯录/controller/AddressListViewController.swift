//
//  AddressListViewController.swift
//  LogisticsManagerProject
//
//  Created by 王岩 on 2018/11/11.
//  Copyright © 2018年 王岩. All rights reserved.
//

import UIKit

class AddressListViewController: BaseViewController {

    var dataController:AddressListDataController!
    @IBOutlet weak var tableView: UITableView!
    var searchContent = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "通讯录"
        initData()
        initUI()
        queryList()
        
    }

}
extension AddressListViewController{
    fileprivate func initData(){
        dataController = AddressListDataController(delegate: self)
        
    }
    
    fileprivate func initUI(){
        self.edgesForExtendedLayout = .top
        initTableView()
    }
    
    fileprivate func initTableView(){
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 56))
        
        let headerView = UIView.loadViewWithName("AddressListHeaderView") as! AddressListHeaderView
        headerView.delegate = self
        headerView.drawInView(view)
        
        tableView.tableHeaderView = view

        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.backgroundColor = UIColor.clear
        tableView.register("AddressListTableViewCell")
       
        
    }
}
extension AddressListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataController.sectionTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataController.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataController.groupedStudents[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return defaultTableViewSectionTitlesArray
        return dataController.sectionTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        LHAlertView.showTipAlertWithTitle("\(title)", postion: .center)
        return dataController.sectionTitles.index(of: title) == nil ? -1 : dataController.sectionTitles.index(of: title)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddressListTableViewCell.loadCell(tableView)
        cell.update(model: dataController.groupedStudents[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataController.groupedStudents[indexPath.section][indexPath.row]
        let phoneNum = "tel:" + model.phone
        let callWebview = UIWebView()
        callWebview.loadRequest(URLRequest.init(url: URL.init(string: phoneNum)!))
        self.view.addSubview(callWebview)
        
    }
    
}
extension AddressListViewController{
    func queryList(){
        let parameter:NSMutableDictionary = [
            "companyId":MyConfig.shared().companyId,
            "name":searchContent,
            
            ]
        dataController.telephoneList(parameter: parameter) { (isSucceed, info) in
            if isSucceed {
                self.tableView.reloadData()
            }else {
                
            }
        }
    }
}
extension AddressListViewController:AddressListSearchProtocol{
    func searchClick(_ content: String) {
        searchContent = content
        queryList()
    }
}
