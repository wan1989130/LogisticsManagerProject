//
//  Config.swift
//  MiddleSchool2_teacher
//
//  Created by 李琪 on 2017/5/4.
//  Copyright © 2017年 李琪. All rights reserved.
//

var isDebugging = false
var NetIsDebugging = false

//屏幕尺寸相关
let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width;
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height


//程序相关
let MyAppID:String = "1445137631" //appId 1402329643
let ProductId:String = "a131be5242a311e8b50500505694781a"//
let GetAreaServerClientIdentifier = "GetAreaServerClientIdentifier"

//默认图片
let defaultImage = UIImage.loadImage("image-placeholder")
let defaultFullScreenImage = UIImage.loadImage("image-fullScreen-placeholder")
let defaultPortraitImage = UIImage.loadImage("defaultPortrait")

//存储当前登录用户信息
var currentUser:UserModel! = UserModel()





enum SelectTimeType{
    case begin
    case end
}

enum DirectionType:Int{
    case first = 0
    case top = 1
    case down = 2
    
}


//系统相关
let systemVersion:Float = Float(UIDevice.current.systemVersion)!    //系统版本号
let appBuildVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String //build版本号


let defaultIntValue:Int = 0
let defaultInt8Value:Int8 = 0
let defaultInt16Value:Int16 = 0
let defaultInt32Value:Int32 = 0
let defaultInt64Value:Int64 = 0
let defaultFloatValue:Float = 0
let defaultDoubleValue:Double = 0
let defaultString = ""

let defaultTableViewSectionTitlesArray = ["#",
                                          "A","B","C","D","E","F","G",
                                          "H","I","J","K","L","M","N",
                                          "O","P","Q",    "R","S","T",
                                          "U","V","W",    "X","Y","Z"
                                          ]
//网络请求
//let HostAddress = "http://118.89.242.54:8090/songsongTown/"
//基础接口
//let GetAreaListHost = "http://192.168.13.3/centsvc/mobile/"      //开发获取区域列表接口地址
//let GetAreaListHost = "http://show.huihaiedu.cn/base_service/mobile/" //演示获取区域列表接口地址
let GetAreaListHost = "http://app.huihaiedu.cn/base_service/mobile/"      //生产获取区域列表接口地址
//用户隐私协议
let StaticProtocoHtml = "resources/common/user_agreement.html"


//测试服务器
//var HostAddress = "http://221.8.52.7:8010/lpsms_client/"
//var FileServerAddress = "http://221.8.52.7:8010/lpsms_client/ph/fileUpload"// 上传文件
//var OcrAddress = "http://139.210.38.78:8030/cxfServerX/doAllCardRecon"//身份证识别
//var FileAccessHost = "http://221.8.52.7:8010/lpsms_client/" // 显示文件
//var DetailImageAccess = "http://139.210.38.75:8020"




//正式服务器
var HostAddress = "http://139.210.38.75:8010/lpsms_client/"
var FileServerAddress = "http://139.210.38.75:8010/lpsms_client/ph/fileUpload"// 上传文件
var OcrAddress = "http://139.210.38.78:8030/cxfServerX/doAllCardRecon"//身份证识别
var FileAccessHost = "http://139.210.38.75:8010/lpsms_client/" // 显示文件
var DetailImageAccess = "http://139.210.38.75:8020"









let HostAddressSandBoxKey = "hostAddressSandBoxKey"
let AreaIdSandBoxKey = "areaIdSandBoxKey"
let AreaNameSandBoxKey = "areaNameSandBoxKey"
let FileServerClientIdentifier = "FileServerClientIdentifier"
let DictionaryServerClientIdentifier = "DictionaryServerClientIdentifier"
let ToolKitServerClientIdentifier = "ToolKitServerClientIdentifier"


var areaId:String{
    get{
        let AreaIdInSandBox = UserDefaults.standard.object(forKey: AreaIdSandBoxKey)
        return AreaIdInSandBox == nil ? "" : AreaIdInSandBox as! String
    }
}

var areaName:String{
    get{
        let AreaNameInSandBox = UserDefaults.standard.object(forKey: AreaNameSandBoxKey)
        return AreaNameInSandBox == nil ? "" : AreaNameInSandBox as! String
    }
}
