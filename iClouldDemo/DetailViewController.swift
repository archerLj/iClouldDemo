//
//  DetailViewController.swift
//  iClouldDemo
//
//  Created by archerLj on 16/4/1.
//  Copyright © 2016年 archerLj. All rights reserved.
//

import UIKit
import PKHUD
import CloudKit

class DetailViewController: UIViewController {

    var record: CKRecord?
    var imageURL: NSURL?
    let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    var image: UIImage?
    
    @IBOutlet weak var goodsNameTextField: UITextField!
    @IBOutlet weak var goodsImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = record {
            setupUI()
            deleteButton.enabled = true
        } else {
            image = UIImage(named: "defaultImage")
            deleteButton.enabled = false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK:- private
    func setupUI() {
        goodsNameTextField.text = record?.valueForKey(textKey) as? String
        let imageAsset: CKAsset = record?.valueForKey(imageKey) as! CKAsset
        image = UIImage(contentsOfFile: imageAsset.fileURL.path!)
        goodsImage.image = image
    }
    
    func saveImage() {
        let imageData: NSData = UIImageJPEGRepresentation(image!, 0.8)!
        let path = documentsDirectoryPath.stringByAppendingPathComponent("tempImageName")
        imageURL = NSURL(fileURLWithPath: path)
        imageData.writeToURL(imageURL!, atomically: true)
    }
    
    // 从iClould上删除一条记录
    func deleteiClould() {
        let recoredID = record?.recordID
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        
        HUD.show(.LabeledProgress(title: "deleting...", subtitle: ""))
        privateDatabase.deleteRecordWithID(recoredID!) { (result, error) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if error != nil {
                    HUD.flash(.Error, delay: 1.0)
                } else {
                    HUD.flash(.Success, delay: 1.0, completion: { (booll) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
            })
        }
    }
    
    // 更新记录到iClould上
    func updateiClould()  {
        
        if let _ = record {
        } else {
            //        To create a unique identifier that will be used as the key for the record. More precisely, not only we need to create such a key, but we must find a way so these keys are unique.
            let timestampAsString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate())
            let timestampParts = timestampAsString.componentsSeparatedByString(".")
            let recordID = CKRecordID(recordName: timestampParts[0])
            //        To create a CKRecord object and “feed” it with all the values that should be stored.
            record = CKRecord(recordType: lfRecordType, recordID: recordID)
        }
        
        record?.setObject(goodsNameTextField.text, forKey: textKey)
        record?.setObject(NSDate(), forKey: dateKey)
        let imageAsset: CKAsset = CKAsset(fileURL: imageURL!)
        record?.setObject(imageAsset, forKey: imageKey)
        //        To specify the container and the database that the data should be stored to.
        let container = CKContainer.defaultContainer()
        let privateDatabase = container.privateCloudDatabase
        //        To perform the actual saving.
        
        HUD.show(.LabeledProgress(title: "updating...", subtitle: ""))
        privateDatabase.saveRecord(record!) { (result, error) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if error != nil {
                    HUD.flash(.Error, delay: 1.0)
                } else {
                    HUD.flash(.Success, delay: 1.0, completion: { (booll) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
            })
        }
    }
    
    // MARK:- event actions
    @IBAction func selectGoodsImage(sender: UIButton) {
        let imagePickerVC: UIImagePickerController = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .PhotoLibrary
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        
        guard goodsNameTextField.text != nil else {
            HUD.flash(.Label("商品名不能为空"), delay: 1.0)
            return
        }
        
        saveImage()
        updateiClould()
    }
    
    @IBAction func deleteAction(sender: UIButton) {
        deleteiClould()
    }

}

// MARK:- delegates
// MARK: UIImagePickerControllerDelegate
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        goodsImage.image = image
    }
}