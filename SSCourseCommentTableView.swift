//
//  SSCourseCommentTableView.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/8.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import AFNetworking

class SSCourseCommentTableView: UITableViewController, SSCourseCellDelegate, UITextFieldDelegate{
    
    //MARK: - ALL properties
    //MARK: -
    
    var dataSourse: [NSDictionary]!
    
    var courseName: String?
    
    // the comment input text field
    lazy private var realCommentInputField: UITextField = {
        let commentInputField = UITextField()
        commentInputField.delegate = self
        commentInputField.returnKeyType = UIReturnKeyType.Send;
        commentInputField.spellCheckingType = UITextSpellCheckingType.No
        commentInputField.autocorrectionType = UITextAutocorrectionType.No
        commentInputField.borderStyle = UITextBorderStyle.RoundedRect
        
        return commentInputField
    }()
    
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
    
    //MARK: - all func next
    //MARK: -
    
    private func commentFiledResignFirstResponder() {
        if realCommentInputField.isFirstResponder() {
            realCommentInputField.resignFirstResponder()
        }
        if fakeCommentInputField.isFirstResponder() {
            fakeCommentInputField.resignFirstResponder()
        }
    }
    
    //MARK: table view delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SSCourseCell.cellHeightWithData(dataSourse, cellWidth: CGRectGetWidth(tableView.bounds))
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier:String = "CourseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SSCourseCell
        
        cell.showTopSeperator = (indexPath.row != 0)
        cell.delegate = self
        cell.configWithData(dataSourse[indexPath.row] as? [String : AnyObject], cellWidth: CGRectGetWidth(tableView.bounds))
        
        return cell
    }
    
    //MARK: - SSCourseCell Protocol didClickReplyButton
    func commentCell(commentCell: SSCourseCell, didClickReplyButton: UIButton) {
        
        NSLog("click the reply button")
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == realCommentInputField{
            commentFiledResignFirstResponder()
            let comment = textField.text
            if comment != nil && comment!.isEmpty == false {
                
                
            }
        }
        
        return true
    }
}
