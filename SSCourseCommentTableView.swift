//
//  SSCourseCommentTableView.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/8.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking
import MJRefresh

var dataSourse: [NSDictionary] = []

class SSCourseCommentTableView: UITableViewController, SSCourseCellDelegate, UITextFieldDelegate{
    
    //MARK: - ALL properties
    //MARK: -
    
    var courseName: String = "testclass"
    
    private var commentOperatingIndexPaths: NSIndexPath?
    private var likeOperatingIndexPaths: NSIndexPath?
    private var isNewComment: Bool = false
    

    // 假评论输入框
    lazy private var fakeCommentInputField: UITextField = {
        
        let fakeTextField = UITextField(frame: CGRectZero)
        fakeTextField.inputAccessoryView = self.fakeCommentInputFieldAccessoryView
        return fakeTextField
    }()
    
    lazy private var fakeCommentInputFieldAccessoryView: UIView = {
        
        let inputAccessoryView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().applicationFrame), 44))
        inputAccessoryView.backgroundColor = UIColor(white: 0.91, alpha: 1)
        
        let commentTextField = self.realCommentInputField
        inputAccessoryView.addSubview(commentTextField)
        
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        inputAccessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[commentTextField]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["commentTextField" : commentTextField]))
        inputAccessoryView.addConstraint(NSLayoutConstraint(item: commentTextField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: inputAccessoryView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        return inputAccessoryView
    }()
    
    // 真正的评论输入框
    lazy private var realCommentInputField: UITextField = {
        let commentInputField = UITextField()
        commentInputField.delegate = self
        commentInputField.returnKeyType = UIReturnKeyType.Send;
        commentInputField.spellCheckingType = UITextSpellCheckingType.No
        commentInputField.autocorrectionType = UITextAutocorrectionType.No
        commentInputField.borderStyle = UITextBorderStyle.RoundedRect
        
        return commentInputField
    }()

    
    //MARK: - all func next
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = courseName
        getDataFromEYCIA()
        tableView.allowsSelection = false
//        dataSourse = dictData["data"] as? [NSDictionary]
        tableView.addSubview(fakeCommentInputField)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    private func commentFiledResignFirstResponder() {
        if realCommentInputField.isFirstResponder() {
            realCommentInputField.resignFirstResponder()
        }
        if fakeCommentInputField.isFirstResponder() {
            fakeCommentInputField.resignFirstResponder()
        }
    }
    
    
    func getDataFromEYCIA(){
        
        let eyciaURL = "http://msghub.eycia.me:4001/Reply/testclass/20/0/-1"

        session.GET(eyciaURL, parameters: nil, success: { (dataTask, response) in
            
            dataSourse = response!["data"] as! [NSDictionary]
//            print(dataSourse)
            self.tableView.reloadData()
            
            }) { (dataTask, error) in
                print(error)
        }
    }
    
    
    //MARK: table view delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SSCourseCell.cellHeightWithData(dataSourse[indexPath.row], cellWidth: CGRectGetWidth(tableView.bounds))
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier:String = "CourseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SSCourseCell
        
        cell.showTopSeperator = (indexPath.row != 0)
        cell.delegate = self
        let indexPathSource = dataSourse[indexPath.row] as? [String : AnyObject]
        cell.configWithData(indexPathSource, cellWidth: CGRectGetWidth(tableView.bounds))
        
        return cell
    }
    
    //FIXME: 处理新评论
    @IBAction func didClickNewCommentButton(sender: UIBarButtonItem) {
        
        if fakeCommentInputField.becomeFirstResponder() {
            realCommentInputField.becomeFirstResponder()
        }
        //set the comment flag is true if the button if newComment button
        isNewComment = true
    }
    
    
    //FIXME: 处理评论
    func commentCell(commentCell: SSCourseCell, didClickReplyButton: UIButton) {
        
        //get the click cell indexPath row
        let commentCellIndexPath = tableView.indexPathForRowAtPoint(tableView.convertPoint(CGPointZero, fromView: commentCell))
        self.commentOperatingIndexPaths = commentCellIndexPath
        doOperateViewComment()
        isNewComment = false
    }
    func doOperateViewComment() {
        print("点击了评论按钮")
        let commentOperatingIndexPath = self.commentOperatingIndexPaths
        if commentOperatingIndexPath != nil && dataSourse.count > commentOperatingIndexPath!.row {
            if fakeCommentInputField.becomeFirstResponder() {
                realCommentInputField.becomeFirstResponder()
            }

        }
    }

    
    
    //FIXME: 处理点赞
    
    func commentCell(commentCell: SSCourseCell, didClickLikeButton: UIButton) {
        let likeCellIndexPath = tableView.indexPathForRowAtPoint(tableView.convertPoint(CGPointZero, fromView: commentCell))
        
        self.likeOperatingIndexPaths = likeCellIndexPath
        doOperateViewLike()
        
    }
    func doOperateViewLike() {
        print("点击了赞按钮")
        let likeOperatingIndexPath = self.likeOperatingIndexPaths
        if likeOperatingIndexPath != nil && dataSourse.count > likeOperatingIndexPath!.row {
            let operateComment = dataSourse[likeOperatingIndexPath!.row]
            
                let diggedID = operateComment["id"] as! String
                let addDiggURL = "http://msghub.eycia.me:4001/Reply/testclass/\(diggedID)/digg/add"
            
                var hasChange = false
                
                var limDic = operateComment as! [String: AnyObject]
                
                if limDic["digged"] as! Bool == false{
                    hasChange = true
                    limDic["digged"] = true
                    limDic["digg"] = limDic["digg"] as! Int + 1
                    dataSourse[likeOperatingIndexPath!.row] = limDic
                    self.tableView.reloadRowsAtIndexPaths([likeOperatingIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
                    
                }else{
                    hasChange = true
                    limDic["digged"] = false
                    limDic["digg"] = limDic["digg"] as! Int - 1
                    dataSourse[likeOperatingIndexPath!.row] = limDic
                    self.tableView.reloadRowsAtIndexPaths([likeOperatingIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
                }
            
                if hasChange{
                    session.POST(addDiggURL, parameters: nil, success: { (dataTask, response) in
                        
                        let isError = response!["err"] as! Int
                        
                        if isError == 0{
                            print(response)
                            //FIXME: submit to the sever

                        }else{
                            let errorMessage = response!["reason"]
                            print(errorMessage)
                        }
                        }, failure: nil)
                }
        }
    }

    
    @IBAction func getBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: UITextFieldViewDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        if textField == realCommentInputField{
            commentFiledResignFirstResponder()
            let comment = textField.text
            let replyComment = SSReplyComment()
            let localDate = NSDate().timeIntervalSince1970
            var urlComment: String!
            if isNewComment{
                urlComment = "http://msghub.eycia.me:4001/testclass/\(comment!)"

                replyComment.content = comment!
                replyComment.authorName = studenInfo["name"]!
                replyComment.stuId = studenInfo["stu_id"]!
                replyComment.time = localDate
                //FIXME: submit reply the new Comment to server
                
                
                
                let addLim = replyComment.getAddLim()
                dataSourse.insert(addLim, atIndex: 0)
            }else{
                if comment != nil && comment!.isEmpty == false {
                    let replyOperationIndex = commentOperatingIndexPaths
                    if replyOperationIndex != nil && dataSourse.count > replyOperationIndex!.row{
                        let replyedComment = dataSourse[(replyOperationIndex?.row)!]
                        
                        replyComment.content = comment!
                        replyComment.authorName = studenInfo["name"]!
                        replyComment.stuId = studenInfo["stu_id"]!
                        
                        replyComment.refId = replyedComment["id"]!
                        replyComment.refedAuthor = replyedComment["authorName"]!
                        replyComment.refedContent = replyedComment["content"]!
                        
                        replyComment.className = replyedComment["className"]!
                        replyComment.time = localDate
                        
                        //FIXME: submit reply Comment to server
                        
                        
                        let addLim = replyComment.getAddLim()
                        dataSourse.insert(addLim, atIndex: 0)
                    }
                }
            }
            
            session.POST(urlComment, parameters: nil, success: { (dataTask, response) in
                
                print(response)
                }, failure: { (dataTask, error) in
                    print(error.localizedDescription)
            })

            tableView.reloadData()
            tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
            textField.text = ""
            
            
        }
        return true
    }
}

extension NSDictionary{
    
    static func loadJSONFromBundle() -> NSDictionary? {
        
        
        if let path = NSBundle.mainBundle().pathForResource("-1", ofType: "json") {
            
            let data: NSData?
            
            do{
                data = try! NSData(contentsOfFile: path, options: NSDataReadingOptions())
            }

            if let data = data {
                do{
                    let dictionary: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                    
                    if let dictionary = dictionary as? NSDictionary {
                        return dictionary
                    } else {
                        print("not valid JSON: (error!)")
                        return nil
                    }

                }catch let error{
                    print(error)
                }
            } else {
                print("Could not load file: (filename), error: (error!)")
                return nil
            }
        } else {
            print("Could not find file: (filename)")
            return nil
        }
        return nil
    }
}
