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
import SVProgressHUD

//save the comment's value
var dataSourse: [NSDictionary] = []

class SSCourseCommentTableView: UITableViewController, SSCourseCellDelegate, UITextFieldDelegate{
    

    
    //MARK: - ------All Properties------
    //MARK: -

    var limComment : SSReplyComment!
    var errorNumber: Int = 0

    //be used to get more comment's url
    var timeLast: Int = -1
    var idLast: String = "0"
    
    //get from last controler view
    var courseName: String = "testclass"
    
    //the reply action, the operation indexPath
    private var commentOperatingIndexPaths: NSIndexPath?
    //the digg action, the operation indexPath
    private var likeOperatingIndexPaths: NSIndexPath?
    
    private var isNewComment: Bool = false
    
    // 假评论输入框
    lazy private var fakeCommentInputField: UITextField = {
        let fakeTextField = UITextField(frame: CGRectZero)
        fakeTextField.inputAccessoryView = self.fakeCommentInputFieldAccessoryView
        return fakeTextField
    }()
    
    lazy private var fakeCommentInputFieldAccessoryView: UIView = {
        let inputAccessoryView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), 44))
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

    



    //MARK: - ------Apple Inc.Func------
    //MARK: -
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLast = -1
        idLast = "0"
        dataSourse = []
        
        self.tableView.allowsSelection = false
        self.tableView.tableFooterView = UIView.init()
        tableView.addSubview(fakeCommentInputField)
        
        getDataFromEYCIA()
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
    
    //MARK: UITextFieldViewDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == realCommentInputField{
            commentFiledResignFirstResponder()
            let comment = textField.text
            
            if comment == ""{
                let alert = UIAlertController(title: nil, message: "请输入评论内容", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: { (nil) in
                    if self.fakeCommentInputField.becomeFirstResponder() {
                        self.realCommentInputField.becomeFirstResponder()
                    }
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                return false
            }
            
            
//            var limComment: SSReplyComment!
//            var errNum: Int = 0
            
            if isNewComment{
                limComment = SSReplyComment(dict: nil, comment: comment!, courseName: self.courseName, isNew: isNewComment)
            }else{
                let replyOperationIndex = commentOperatingIndexPaths
                if replyOperationIndex != nil && dataSourse.count > replyOperationIndex!.row{
                    let replyedComment = dataSourse[(replyOperationIndex?.row)!]
                    limComment = SSReplyComment(dict: replyedComment, comment: comment!, courseName: self.courseName, isNew: isNewComment)
                }
            }
            
            errorNumber = limComment.errNumber
            
            
            
            let myQueue = Singleton.sharedInstance
            dispatch_async(myQueue, {
                //TODO: RunLoop
                
                let runloop: NSRunLoop = NSRunLoop.currentRunLoop()
                
                let mtyTimer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(SSCourseCommentTableView.getErrorNum), userInfo: nil, repeats: false)
                
                runloop.addTimer(mtyTimer, forMode: NSDefaultRunLoopMode)
                runloop.run()
            })

            if errorNumber == 0{
                let addLim = limComment.getNewDict
                dataSourse.insert(addLim, atIndex: 0)
                
                self.tableView.reloadData()
                self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                textField.text = ""
            }else{
                //none
            }
            
        }
        return true
    }
    
    
    //MARK: - ------Individual Func------
    //MARK: -
    
    
    func getErrorNum(){
        self.errorNumber = self.limComment.errNumber
//        print(self.errorNumber)
        
        if self.errorNumber == 0{
            let limDataSource = NSMutableDictionary(dictionary: dataSourse.first!)
            limDataSource["id"] = limComment.id
            limDataSource as NSDictionary
            dataSourse.removeFirst()
            dataSourse.insert(limDataSource, atIndex: 0)
        }else{
            dispatch_async(dispatch_get_main_queue(), { 
                dataSourse.removeFirst()
                self.tableView.reloadData()
                
                
            })
        }
    }
    
    

    /*
        the method to 'resignFirstResponder' fack and real inputTextField
    */
    private func commentFiledResignFirstResponder() {
        if realCommentInputField.isFirstResponder() {
            realCommentInputField.resignFirstResponder()
        }
        if fakeCommentInputField.isFirstResponder() {
            fakeCommentInputField.resignFirstResponder()
        }
    }
    
    
    
    /*
        the method be tiggered in footer refresh's action
    */
    func footerRefresh(){
        
        //the last comment which you can look in the tableview currently
        let nowDataSourseLast = dataSourse.last!
        
        //the last comment's ID
        idLast = nowDataSourseLast["id"] as! String
        //the last comment's public time
        timeLast = nowDataSourseLast["time"] as! Int
    
        print("use the footer refresh")
        
        /*
            get more data from server, URL: "http://msghub.eycia.me:4001/Reply/course/courseName/20/idLast/timeLast"
                courseNmae: the currnent comment zoon's title
                20        : get 20 commnet one
                idLast    : the currunt data's last commmnet's ID
                timeLast  : the currunt data's last commmnet publiced date -> it is a time stemp(时间戳)
        */
        let limURL =  "http://msghub.eycia.me:4001/Reply/course/\(courseName)/20/\(idLast)/\(timeLast)"
        
        //use to mark if connet or get back data is error
        var isError = 0
        
        session.GET(limURL, parameters: nil, success: { (dataTask, response) in
            
            isError = response!["err"] as! Int
            if isError == 1{
                
                // do something if found the get back data is error
            }else{
                
                // append the 20 new comment to the dataSource
                let limDataSourse = response!["data"] as! [NSDictionary]
                dataSourse.insertContentsOf(limDataSourse, at: dataSourse.count)
            }
        }) { (dataTask, error) in
            
            isError = 1
            print(error.localizedDescription)
        }
        
        //stop the refresh statue
        self.tableView.mj_footer.endRefreshing()
        
        //if get data success, reload the tableview
        if isError != 1{
            self.tableView.reloadData()
        }
    }
    
    /*
        after enter the comment view, the first time to get the first 20 comment
     
            then get more commnet via footerRefresh's action -> 'footerRefresh'
    */
    func getDataFromEYCIA(){
        
        
        /*
             idLast, timeLast all are the init value
                idLast : "0"
                timeLast : -1
        */
        let eyciaURL = "http://msghub.eycia.me:4001/Reply/course/\(courseName)/20/\(idLast)/\(timeLast)"
        
        session.GET(eyciaURL, parameters: nil, success: { (dataTask, response) in
            dataSourse = response!["data"] as! [NSDictionary]
            if dataSourse.isEmpty{
                SVProgressHUD.showErrorWithStatus("目前还没有没有评论")
                
                //TODO: change the background image
                
            }else{
                
                self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(SSCourseCommentTableView.footerRefresh))
                self.tableView.reloadData()
            }
            
            }) { (dataTask, error) in
                print(error)
        }
    }
    
    //FIXME: 处理新评论
    @IBAction func didClickNewCommentButton(sender: UIBarButtonItem) {
        
        if fakeCommentInputField.becomeFirstResponder() {
            realCommentInputField.placeholder = ""
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
//                print(dataSourse[(commentOperatingIndexPath?.row)!])
                let replyedName = dataSourse[(commentOperatingIndexPath?.row)!]["authorName"] as! String
                realCommentInputField.placeholder = "回复 \(replyedName)"
                realCommentInputField.becomeFirstResponder()
            }
        }
    }


    /*
        handle the click digg button action
     
            1. get the cell's indexPath which you click digged, then tigger 'doOperateViewLike' method
     
            2.  ~~~
     */
    
    func commentCell(commentCell: SSCourseCell, didClickLikeButton: UIButton) {
        let likeCellIndexPath = tableView.indexPathForRowAtPoint(tableView.convertPoint(CGPointZero, fromView: commentCell))
        
        self.likeOperatingIndexPaths = likeCellIndexPath
        doOperateViewLike()
        
    }
    func doOperateViewLike() {
        print("点击了赞按钮")
        let likeOperatingIndexPath = self.likeOperatingIndexPaths
        if likeOperatingIndexPath != nil && dataSourse.count > likeOperatingIndexPath!.row {
            let operateComment = dataSourse[likeOperatingIndexPath!.row] as! Dictionary<String, AnyObject>
            
                let diggedID = operateComment["id"] as! String
            
                /*
             
                */
                let addDiggURL = "http://msghub.eycia.me:4001/Reply/\(diggedID)/digg/add"
            
                var limDic = operateComment
                if limDic["digged"] as! Bool == false{
                    
                    limDic["digged"] = true
                    limDic["digg"] = limDic["digg"] as! Int + 1

                    dataSourse[likeOperatingIndexPath!.row] = limDic
                    self.tableView.reloadRowsAtIndexPaths([likeOperatingIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
                    session.POST(addDiggURL, parameters: nil, success: { (dataTask, response) in
                        
                        let isError = response!["err"] as! Int
                        if isError == 0{
                            
                        }else{
                            let errorMessage = response!["reason"]
                            print(errorMessage)
                            limDic["digged"] = false
                            limDic["digg"] = limDic["digg"] as! Int - 1
                            dataSourse[likeOperatingIndexPath!.row] = limDic
                            self.tableView.reloadRowsAtIndexPaths([likeOperatingIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
                        }
                        }, failure: { (dataTask, error) in
                            NSLog("find it is error")
                            print(error.localizedDescription)
                            
                            limDic["digged"] = false
                            limDic["digg"] = limDic["digg"] as! Int - 1
                            dataSourse[likeOperatingIndexPath!.row] = limDic
                            self.tableView.reloadRowsAtIndexPaths([likeOperatingIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
                            
                    })

                }
        }
    }

    
    @IBAction func getBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

/*
    singleton 单例模式
        create a single dispatch queue
*/
class Singleton {
    class var sharedInstance: dispatch_queue_t {
        get {
            struct SingletonStruct {
                static var onceToken:dispatch_once_t = 0
                static var singleton: dispatch_queue_t?
            }
            dispatch_once(&SingletonStruct.onceToken, { () -> Void in
                SingletonStruct.singleton = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT)
            })
            return SingletonStruct.singleton!
        }
    }
}