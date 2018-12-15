//
//  ContentBlockerRequestHandler.swift
//  Blocker
//
//  Created by Admin on 12/14/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    
    func beginRequest(with context: NSExtensionContext) {
        
        let file = "blockSite.json"
        
        if let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.blockit") {
            
            let path = dir.appendingPathComponent(file)
            
            do {
                do {
                    let attachment =  NSItemProvider(contentsOf: path)!
                    let item = NSExtensionItem()
                    item.attachments = [attachment]
                    context.completeRequest(returningItems: [item], completionHandler: nil)
                }
            }
        }
    }
}

//class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
//
//    func beginRequest(with context: NSExtensionContext) {
//        let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!
//
//        let item = NSExtensionItem()
//        item.attachments = [attachment]
//
//        let url = buildJSONFileURL()
//        if let attachment = NSItemProvider(contentsOf: url as URL) { item.attachments = [attachment] }
//
//        context.completeRequest(returningItems: [item], completionHandler: nil)
//    }
//
//    func buildJSONFileURL() -> NSURL {
//        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
//        let path = directory.appendingPathComponent("blockerList.json")
//
//        let dictionary = [[
//            "action": [ "type": "block"],
//            "trigger": [ "url-filter": "www.google.com" ]
//            ]]
//
//        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
//        let text = String(data: data, encoding:String.Encoding.ascii)!
//
//        try! text.write(toFile: path, atomically: true, encoding: String.Encoding.ascii)
//
//        return NSURL(fileURLWithPath: path)
//    }
//}
