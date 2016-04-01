//
//  ViewController.swift
//  iClouldDemo
//
//  Created by archerLj on 16/4/1.
//  Copyright © 2016年 archerLj. All rights reserved.
//

import UIKit
import CloudKit
import PKHUD

let lfRecordType = "LFRecode"
let cellReuseID = "reuseID"
let imageKey = "recordImage"
let textKey = "recordText"
let dateKey = "recordDate"
class ViewController: UIViewController {

    var mainTableView: UITableView?
    var recodesArr: Array<CKRecord> = []
    
    // MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recodesArr.removeAll()
        fetchiCLould()
    }
    
    // MARK:- private
    func setupTableView() {
        mainTableView = UITableView(frame: self.view.bounds, style: .Plain)
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        view.addSubview(mainTableView!)
    }
    
    func fetchiCLould() {
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        let pridacate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: lfRecordType, predicate: pridacate)
        
        
        HUD.show(.LabeledProgress(title: "downLoading...", subtitle: ""))
        privateDatabase.performQuery(query, inZoneWithID: nil) { (results, error) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if error != nil {
                    HUD.flash(.Error, delay: 1.0)
                } else {
                    HUD.flash(.Success, delay: 1.0)
                    // MARK UNDO
                    for result in results! {
                        self.recodesArr.append(result as CKRecord)
                    }
                    self.mainTableView?.reloadData()
                }
            })
        }
    }
}

// MARK:- delegates
// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recodesArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellReuseID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellReuseID)
        }
        
        let record: CKRecord = recodesArr[indexPath.row]
        let imageAsset: CKAsset = record.valueForKey(imageKey) as! CKAsset
        
        cell!.imageView!.image = UIImage(contentsOfFile: imageAsset.fileURL.path!)
        cell!.textLabel!.text = record.valueForKey(textKey) as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let record: CKRecord = recodesArr[indexPath.row]
        let detailVC: DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailVC") as! DetailViewController
        detailVC.record = record
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}