//
//  SiteViewController.swift
//  BlockIT
//
//  Created by Admin on 12/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SafariServices

class SiteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var arName = ["instagram.com", "twitter.com"]
   
    
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtSiteName: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Blocked Website"
        self.navigationItem.setHidesBackButton(true, animated:false);
        let logout = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutAction))
        navigationItem.rightBarButtonItems = [logout]
        
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Bhadasia.BlockIT.Blocker", completionHandler: nil)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        tblView.addGestureRecognizer(longPress)

    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        cell.textLabel?.text = arName[indexPath.row]
        return cell
    }
    
    
    
    
   
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            let isValid = isValidURL(strURL: updatedText)
            if isValid {
                btnSubmit.isEnabled = true
                btnSubmit.alpha = 1.0;
            } else {
                btnSubmit.isEnabled = false
                btnSubmit.alpha = 0.5;
            }
        }
        return true
        
    }

    @objc func logOutAction() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController?.popToViewController(viewControllers[0], animated: true)
    }
    @IBAction func submitClicked(_ sender: Any) {
        
        if isValidURL(strURL: txtSiteName.text!) {
            arName.append(txtSiteName.text!)
        }
        tblView.reloadData()
        txtSiteName.text = ""
        addOrDeleteBlockSites()
    }

    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in:tblView)
            if let indexPath = tblView.indexPathForRow(at: touchPoint) {
                
                arName.remove(at: indexPath.row)
                tblView.deleteRows(at:[indexPath] , with: .left)
                addOrDeleteBlockSites()
                // add your code here
                // you can use 'indexPath' to find out which row is selected
                
            }
        }
    }

    func isValidURL(strURL:String) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: strURL)
    }

//    func isValidURL(urlString: String?) -> Bool {
//        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
//        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with:urlString)
//    }
    
    func getAllBlockSites(arSites:Array<String>) -> Array<Any>  {
        
        var arBlocks = [Any]()

        for obj in arSites {
            let dict = ["action": [ "type": "block"],"trigger": [ "url-filter": obj]]
            arBlocks.append(dict)
        }
        return arBlocks
    }
    
    func addOrDeleteBlockSites()  {
        
//        let webFilters = [[
//            "action": [ "type": "block"],
//            "trigger": [ "url-filter": "www.bing.com"]
//            ]]
        
        let webFilters = getAllBlockSites(arSites: arName)
       // print(webFilters)
        
        
        let jsonData = try! JSONSerialization.data(withJSONObject:webFilters, options: JSONSerialization.WritingOptions.prettyPrinted)
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            
            let file = "blockSite.json"
            if let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.blockit") {
                let path = dir.appendingPathComponent(file)
                
                do {
                    try JSONString.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                    let id = "Bhadasia.BlockIT.Blocker"
                    SFContentBlockerManager.reloadContentBlocker(withIdentifier: id) {error in
                        
                        guard error == nil else {
                            print(error ?? "Error")
                            return
                        }
                        print("Successfully blocked and reloaded")
                    }
                }
                catch {
                }
            }
        }
    }
}
