//
//  PersonRegisterViewController.swift
//  Logistics
//
//  Created by 王岩 on 2018/5/23.
//  Copyright © 2018年 王岩. All rights reserved.
//

import UIKit

class PersonRegisterViewController: BaseViewController {
    
    var companyModel = SelectCompanyModel()
    @IBAction func confirmClick(_ sender: Any) {

        closeKeyboard()
        if checkFun(){
            checkPassword()
        }
        
        
    }
    @IBOutlet weak var companyNameLabel: UILabel!
   
    
    @IBAction func selectCompanyClick(_ sender: Any) {
        pushViewController("SelectCompanyViewController", sender: nil) { (info) in
            self.companyModel = info as! SelectCompanyModel
            self.companyNameLabel.text = self.companyModel.name
        }
    }
    
    

    //姓名
    @IBOutlet weak var nameTextField: UITextField!
    //用户名
    @IBOutlet weak var userNameTextField: UITextField!
    //密码
    @IBOutlet weak var passwordTextField: UITextField!
    var dataController:PersonRegisterDataController!
    
    @IBOutlet var getCodeButton: UIButton!
    
    @IBAction func isShowPasswordBtn(_ sender: Any) {
        let button = sender as! UIButton
        
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordTextField.font = UIFont.init(name: "System", size: 14)
        passwordTextField.font = UIFont.systemFont(ofSize: 14)
        if passwordTextField.isSecureTextEntry{
            button.setImage(UIImage(named: "icon_password_hide"), for: .normal)
            
            
        }else{
            button.setImage(UIImage(named: "icon_password_show"), for: .normal)
            
        }
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "账号注册"
        
        initData()
        initUI()
    }
    
    
    
}
extension PersonRegisterViewController{
    fileprivate func initUI(){
       
        
    }
    fileprivate func initData(){
        dataController = PersonRegisterDataController(delegate: self)
       
        
    }
}
extension PersonRegisterViewController{
    
    fileprivate func checkFun() -> Bool{
        
        if companyModel.id == ""{
            LHAlertView.showTipAlertWithTitle("请选择所属单位")
            return false
        }
        if String.isNilOrEmpty(nameTextField.text){
            LHAlertView.showTipAlertWithTitle("请输入姓名")
            return false
        }
        if String.isNilOrEmpty(userNameTextField.text){
            LHAlertView.showTipAlertWithTitle("请输入用户名")
            return false
        }
        if String.isNilOrEmpty(passwordTextField.text){
            LHAlertView.showTipAlertWithTitle("请输入密码")
            return false
        }
       
        return true
    }
    
    //验证密码是否有效
    fileprivate func checkPassword(){
        let parameter:NSMutableDictionary = [
            "password":passwordTextField.text!,
            
            ]
        
        
        dataController.checkPassword(parameter: parameter) { (isSucceed, info) in
            if isSucceed {
                self.addUser()
            }
        }
    }
    //添加注册的新用户
    fileprivate func addUser(){
        let parameter:NSMutableDictionary = [
            "loginName":userNameTextField.text!,
            "name":nameTextField.text!,
            "pwd":passwordTextField.text!,
            "companyId":companyModel.id
            
            ]
        
        
        dataController.addUser(parameter: parameter) { (isSucceed, info) in
            if isSucceed {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

