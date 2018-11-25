//
//  HSEncryptionManager.swift
//  HandleSchool
//
//  Created by 李琪 on 16/6/6.
//  Copyright © 2016年 Huihai. All rights reserved.
//

import UIKit
import Foundation

var HSEncryptionManagerInstance:HSEncryptionManager!
class HSEncryptionManager {
    // 编码长度索引1
    let CODE_LEN_IDX1 = 3
    // 编码长度索引2
    let CODE_LEN_IDX2 = 6
    // 键编码长度
    let CODE_LENGTH = 6
    // 编码键表
    let CODE_KEYS = [
        "0","1","2","3","4","5","6","7","8","9",
        "a","b","c","d","e","f","g","h","i","j",
        "k","l","m","n","o","p","q","r","s","t",
        "u","v","w","x","y","z","A","B","C","D",
        "E","F","G","H","I","J","K","L","M","N",
        "O","P","Q","R","S","T","U","V","W","X",
        "Y","Z","!","@","#","$","%","^","&","*",
        "(",")","+","="]
    // 编码值表
    let CODE_TABLE:Array<UInt8> = [
    0x57, 0x61, 0x1F, 0x14, 0x1D, 0x1D, 0x7A, 0x3F,
    0x3F, 0x1A, 0x1A, 0x7D, 0x56, 0x30, 0x22, 0x4A,
    0x7E, 0x41, 0x64, 0x2A, 0x5B, 0x3D, 0x42, 0x75,
    0x7F, 0x0A, 0x75, 0x50, 0x45, 0x60, 0x42, 0x08,
    0x24, 0x0E, 0x57, 0x5F, 0x10, 0x5D, 0x46, 0x56,
    0x3D, 0x50, 0x17, 0x01, 0x06, 0x05, 0x6B, 0x6E,
    0x70, 0x59, 0x21, 0x14, 0x44, 0x24, 0x4F, 0x32,
    0x44, 0x59, 0x2C, 0x43, 0x71, 0x6D, 0x22, 0x22,
    0x77, 0x2F, 0x06, 0x29, 0x33, 0x36, 0x1E, 0x47,
    0x58, 0x16, 0x70, 0x4A, 0x0F, 0x28, 0x59, 0x7D,
    0x44, 0x0F, 0x27, 0x76, 0x5C, 0x3A, 0x6A, 0x4C,
    0x7E, 0x06, 0x4D, 0x65, 0x27, 0x33, 0x27, 0x79,
    0x21, 0x43, 0x33, 0x2A, 0x68, 0x5D, 0x02, 0x70,
    0x69, 0x34, 0x53, 0x00, 0x10, 0x70, 0x3D, 0x6F,
    0x38, 0x71, 0x61, 0x02, 0x1C, 0x22, 0x2C, 0x6E,
    0x40, 0x56, 0x73, 0x51, 0x07, 0x79, 0x25, 0x16
    ]
    // 公钥
    let PUBLIC_KEY = "qwerpoiu"
    // AES密钥
    let AESKey = "E2d0u1P6lHahtkjk"
    
    
    class func sharedInstance() -> HSEncryptionManager{
        if HSEncryptionManagerInstance == nil{
            HSEncryptionManagerInstance = HSEncryptionManager()
        }
        return HSEncryptionManagerInstance
    }
    
    func getToken() -> String{
        var sbCodeKey = [String]()
        let codeValues = NSMutableData()
        let max:UInt32 = NSNumber(value: CODE_KEYS.count as Int).uint32Value
        
        
        while sbCodeKey.count < CODE_LENGTH {
            let codeIndex = random(max)
            let key = CODE_KEYS[codeIndex]
            if sbCodeKey.index(of: key) == nil{
                sbCodeKey.append(key)
                codeValues.append([CODE_TABLE[codeIndex]], length: 1)
            }
        }
        
        // user id
        var userId = "ios"
//        if currentUser == nil || currentUser.userId == defaultInt64Value{
//            let temp = NSMutableString(string: String(8000 + random(100000), radix:16))
//            let insertIndex = random(NSNumber(value: temp.length as Int).uint32Value)
//            let insertCharAscii = ("g" as NSString).character(at: 0) + NSNumber(value: random(20) as Int).uint16Value
//            let insertChar = NSString(format: "%c", insertCharAscii) as String
//            temp.insert(insertChar, at: insertIndex)
//            userId = temp as String
//            
//        }
//        else{
//            userId = currentUser.userId  //String(currentUser.userId, radix:16)
//        }
        let len = CODE_KEYS[(userId as NSString).length]
        sbCodeKey.append(len)
        sbCodeKey.append(userId as String)
        
        //时间戳
        let timeInterval = NSNumber(value: Date().timeIntervalSince1970 * 1000 as Double).uint64Value
        let ms = String(timeInterval, radix:16)
        sbCodeKey.append(ms)
        
        //AES加密
        let AESEncodeData = AESEncoder.encryptAESData(charArraytoString(sbCodeKey) as String , app_key: AESKey)
//        let tempString = AESEncodeData!.hexString()
//        let tempNSString = tempString as NSString
        let encodeKey = AESEncodeData!.hexString().replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "") as NSString
      
        let length = NSString(format: "%02x", encodeKey.length)
        
        let keyText:String = encodeKey.substring(to: CODE_LEN_IDX1) +
            String(length.substring(with: NSMakeRange(0, 1))) +
            encodeKey.substring(with: NSMakeRange(CODE_LEN_IDX1, CODE_LEN_IDX2 - CODE_LEN_IDX1 - 1)) +
            String(length.substring(with: NSMakeRange(1, 1))) +
            encodeKey.substring(from: CODE_LEN_IDX2 - 1)
        
        //MD5
        var data = (userId + PUBLIC_KEY + ms).data(using: String.Encoding.utf8)
        if data == nil{
            data = Data()
        }
        let signData = NSMutableData()
        signData.append(codeValues.subdata(with: NSMakeRange(0, CODE_LENGTH)))
        signData.append(data!)
        let signText = MD5Encoder.encrypt(signData as Data!)
        
        let token = keyText + signText!
        return token
    }
    
    fileprivate func random(_ value:UInt32) -> Int{
        return NSNumber(value: arc4random_uniform(value) as UInt32).intValue
    }
    
    fileprivate func charArraytoString(_ array:Array<String>) -> String{
        var result = ""
        for str in array{
            result = result + str
        }
        return result
    }
    
}









































