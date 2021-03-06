//
//  BaseTabBarViewController.swift
//  MiddleSchool2_teacher
//
//  Created by 李琪 on 2017/5/4.
//  Copyright © 2017年 李琪. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    func setupTabBar(){
        //首页
        let firstVC = DeliverGoodsViewController(nibName: "DeliverGoodsViewController", bundle: nil)
        addChildViewController(firstVC, title: "发货管理", image: "nav1_normal", selectedImage: "nav1_hover")
        
        //综合查询
        let secondVC = ComprehensiveQueryListViewController(nibName: "ComprehensiveQueryListViewController", bundle: nil)
        addChildViewController(secondVC, title: "综合查询", image: "nav2_normal", selectedImage: "nav2_hover")
        
        //通讯录
        let thirdVC = AddressListViewController(nibName: "AddressListViewController", bundle: nil)
        addChildViewController(thirdVC, title: "通讯录", image: "nav3_normal", selectedImage: "nav3_hover")
        
        //分析统计
        let fourVC = AnalysisViewController(nibName: "AnalysisViewController", bundle: nil)
        addChildViewController(fourVC, title: "分析统计", image: "nav4_normal", selectedImage: "nav4_hover")
        //资讯信息
        let fivewVC = InformationMessageViewController(nibName: "InformationMessageViewController", bundle: nil)
        addChildViewController(fivewVC, title: "资讯信息", image: "nav5_normal", selectedImage: "nav5_hover")
        
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(hexString:"9A9A9A"), NSAttributedString.Key.font:UIFont.systemFont(ofSize: 11)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(hexString:"34befc"), NSAttributedString.Key.font:UIFont.systemFont(ofSize: 11)], for: .selected)

    }
    
    func addChildViewController(_ childController:UIViewController, title:String, image:String, selectedImage:String){
        if title == "我的"{
            childController.tabBarItem.title = title
        }else{
            childController.title = title
        }
        

        
        childController.tabBarItem.image = UIImage.loadImage(image).withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage.loadImage(selectedImage).withRenderingMode(.alwaysOriginal)
 
        
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(hexString:"9A9A9A")], for: .normal)
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(hexString:"34befc")], for: .selected)
        let mainNav = BaseNavigationViewController(rootViewController: childController)
        addChild(mainNav)
    }
}
