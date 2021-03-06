//
//  LoginViewController.swift
//  BatterProject
//
//  Created by 王岩 on 2017/7/10.
//  Copyright © 2017年 MR. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    //注册
    @IBAction func registerClick(_ sender: Any) {
        pushViewController("PersonRegisterViewController")
    }
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var loginBtn: UIButton!
    //密码
    @IBOutlet weak var passwordTextField: UITextField!
    //用户名
    @IBOutlet weak var userNameTextField: UITextField!
    
    var dataController:LoginDataController!
    
    
    //忘记密码
    @IBOutlet var forgetPasswordBtn: UIButton!
    //个人注册
    @IBOutlet var personRegisterBtn: UIButton!
    //企业注册
    @IBOutlet var companyRegisterBtn: UIButton!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func forgetPwdButtonClicked(_ sender: UIButton) {
//       pushViewController("SuggestionViewController")
        pushViewController("ForgetPwdViewController")
    }
    @IBAction func personRegisterClick(_ sender: Any) {
        pushViewController("PersonRegisterViewController")
    }
    @IBAction func companyRegisterClick(_ sender: Any) {
        pushViewController("CompanyRegisterViewController")
    }

    
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
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        closeKeyboard()
//           self.showMainTab()
        if !checkFun(){
            return
        }

        let parameter:NSMutableDictionary = [
            "loginName":userNameTextField.text!,
            "passWord":passwordTextField.text!,

        ]
        dataController.login(parameter: parameter) { (isSucceed, info) in
            if isSucceed {
                MyConfig.shared().loginName = self.userNameTextField.text!
                MyConfig.shared().passWord = self.passwordTextField.text!
                self.showMainTab()
            }else {

            }
        }
    }
    
    func checkFun() -> Bool{
     
        if String.isAllApacing(str: userNameTextField.text){
            LHAlertView.showTipAlertWithTitle("用户名不能为空")
            return false
        }
        if String.isAllApacing(str: passwordTextField.text){
            LHAlertView.showTipAlertWithTitle("密码不能为空")
            return false
        }
        return true
    }
}

extension LoginViewController{
    //跳转至主页
    fileprivate func showMainTab(){
        
        
        
     
//        MyConfig.shared().isLogin = true
        
        let tabbarVC = BaseTabBarViewController()
        UIApplication.shared.keyWindow?.rootViewController = tabbarVC
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        UIApplication.shared.keyWindow?.layer.add(CATransition.animationWithType(.push, direction: .top), forKey: nil)
    }
    
    fileprivate func initData(){
        dataController = LoginDataController(delegate: self)
        
    }
    
    fileprivate func initUI(){
        registerButton.layer.borderColor = UIColor(hexString: "1999D9")?.cgColor
        registerButton.layer.borderWidth = 1
        if MyConfig.shared().loginName != "" && MyConfig.shared().passWord != ""{
            userNameTextField.text = MyConfig.shared().loginName
            passwordTextField.text = MyConfig.shared().passWord
        }
    }
   
}
extension LoginViewController{
   
   
    
}
