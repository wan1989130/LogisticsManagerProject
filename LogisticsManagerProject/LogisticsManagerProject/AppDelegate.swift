//
//  AppDelegate.swift
//  MiddleSchool2_teacher
//
//  Created by 李琪 on 2017/5/2.
//  Copyright © 2017年 李琪. All rights reserved.
//

import UIKit
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        SQLiteManager.sharedTools
        
        //创建window
        loadWindow()
        let loginVC = LanchImageViewController(nibName: "LanchImageViewController", bundle: nil)
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
        //初始化网络请求组件
        initBaseClient()
        
        //根据应用版本及登录状态跳转至相应页面
        self.performToTargetVCAccordingToVersionAndLoginStatus()
        
       
        
        
        //隐藏键盘工具条
        keyManager()
        
//        UITableView.appearance().estimatedRowHeight = UIScreen.main.bounds.size.height
        
        UITabBar.appearance().backgroundImage=UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        //ios12.1tabBar 中的图标及文字出现位置偏移动画
        //https://blog.csdn.net/longge_li/article/details/83654333
        UITabBar.appearance().isTranslucent = false
        //skphoto内存缓存图片
        //                SKCache.sharedCache.removeAllImages()
        
        
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        MSVersionManager.sharedInstance().checkAppStoreVersion()
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    

    
    
}

