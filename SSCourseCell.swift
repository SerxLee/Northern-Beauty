//
//  SSCourseCell.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/8.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

//
class SSCourseCell: UITableViewCell {
    
    
    //MARK: - all the properties
    //MARK: -
    
    var delegate: SSCourseCellDelegate?

    
    var showTopSeperator: Bool = false {
        didSet {
            topSeperator?.hidden = !showTopSeperator
        }
    }
    
    var test: Bool = false

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var lastCommentTextView: UITextView!
    @IBOutlet weak var sentTime: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var topSeperator: UIView!
    @IBOutlet weak var lastCommentSeperator: UIView!
    
    @IBOutlet weak var topSeperatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastCommentShowViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastCommentShowViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastCommentTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastCommentTextViewHeightConstraint: NSLayoutConstraint!
    
    let commentUrl = ""
    
    //MARK: - all the func
    //MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()

        topSeperator?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        topSeperatorHeightConstraint?.constant = 0.5

        commentTextView.backgroundColor = UIColor.clearColor()
        commentTextView.scrollEnabled = false
        commentTextView.showsVerticalScrollIndicator = false
        commentTextView.showsHorizontalScrollIndicator = false
        commentTextView.editable = false
        commentTextView.selectable = false
        commentTextView.userInteractionEnabled = false
        
//        lastCommentTextView.backgroundColor = UIColor.lightGrayColor()
        lastCommentTextView.scrollEnabled = false
        lastCommentTextView.showsVerticalScrollIndicator = false
        lastCommentTextView.showsHorizontalScrollIndicator = false
        lastCommentTextView.editable = false
        lastCommentTextView.selectable = false
        lastCommentTextView.userInteractionEnabled = false
        
        sentTime?.backgroundColor = UIColor.clearColor()

        
        replyButton.addTarget(self, action: #selector(SSCourseCell.clickReplyButton(_:)), forControlEvents: .TouchUpInside)
        likeButton.addTarget(self, action: #selector(SSCourseCell.clickLikeButton(_:)), forControlEvents:
        .TouchUpInside)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static func cellHeightWithData(data: AnyObject?, cellWidth: CGFloat) -> CGFloat{
        
        var cellHeight: CGFloat = 0
        
        let studentName = data?["authorName"] as? String
        let textContent = data?["content"] as? String
        let lastStudentName = data?["refedAuthor"] as? String
        let lastcomment = data?["refedContent"] as? String
        
        let commentTextViewWidth = cellWidth - mainCommentTextViewLittleThanCellWidth
        
        //set the main comment show view
        
        let commentAttributedText = SSCourseCell.buildCommmentTextViewAttributedTextWithAuthorName(studentName, commentTextContent: textContent)
        let commentTextHeight = SSCourseCell.commentTextViewHeightWithAttributedText(commentAttributedText, commentTextViewWidth: commentTextViewWidth)
        cellHeight += commentTextHeight
 
        //set the last comment show view
        if !(lastcomment!.isEmpty) && lastcomment != ""{
            let lastCommentSeperatorWidth = commentTextViewWidth - lastCommentTextViewLittleThanCommentWidth
            let lastCommentAttributedText = SSCourseCell.buildCommmentTextViewAttributedTextWithAuthorName(lastStudentName, commentTextContent: lastcomment)
            cellHeight += SSCourseCell.commentTextViewHeightWithAttributedText(lastCommentAttributedText, commentTextViewWidth: lastCommentSeperatorWidth)
            cellHeight += lastCommentShowViewTopMargin
        }
        
        //set the create date label
        cellHeight += (commentCreateDateLabelHeight + commentCreateDateLabelTopMargin + commentCreateDateLabelBottomMargin)
        
        //
        let limHeight = cellHeight > commentCellMinHeight ? cellHeight + 22.0: commentCellMinHeight
        return limHeight
    }
    
    func configWithData(data: [String: AnyObject]!, cellWidth: CGFloat = 0){
        let studentName = data?["authorName"] as? String
        let textContent = data?["content"] as? String
        let lastStudentName = data?["refedAuthor"] as? String
        let lastcomment = data?["refedContent"] as? String
        let createDate = data?["time"]  as? Int
        let like = data?["digg"] as? Int
        let digged = data!["digged"] as! Int
        
        let commentTextViewWidth = cellWidth - mainCommentTextViewLittleThanCellWidth
        
        // 设置文字内容
        let commentAttributedText = SSCourseCell.buildCommmentTextViewAttributedTextWithAuthorName(studentName, commentTextContent:textContent)
        commentTextViewHeightConstraint.constant = SSCourseCell.commentTextViewHeightWithAttributedText(commentAttributedText, commentTextViewWidth: commentTextViewWidth)
        self.commentTextView.attributedText = commentAttributedText
        
        // 设置时间
        let date = NSDate(timeIntervalSince1970: Double(createDate!)).fullDescription()

        
        sentTime.text = String(date)
        
        //set show like label
        self.likeNum.text = String(like!)
        
        //set show like button image
        if digged == 1{
            let redheart = UIImage(named: "redHeart")
            self.likeButton.setImage(redheart, forState: UIControlState.Normal)
        }else{
            let blackheart = UIImage(named: "blackHeart")
            self.likeButton.setImage(blackheart, forState: UIControlState.Normal)
        }
        
        //MARK:set the last comment show view
        if !(lastcomment!.isEmpty){
            let lastCommentSeperatorWidth = commentTextViewWidth - lastCommentTextViewLittleThanCommentWidth
            let lastCommentAttributedText = SSCourseCell.buildCommmentTextViewAttributedTextWithAuthorName(lastStudentName, commentTextContent: lastcomment)
            let limHeight:CGFloat = SSCourseCell.commentTextViewHeightWithAttributedText(lastCommentAttributedText, commentTextViewWidth: lastCommentSeperatorWidth)
            lastCommentTextViewHeightConstraint.constant = limHeight + 5
            lastCommentShowViewHeightConstraint.constant = limHeight + 5
            lastCommentSeperator.layer.cornerRadius = 5.0
            lastCommentSeperator.layer.masksToBounds = true
            
            lastCommentSeperator.hidden = false

            self.lastCommentTextView.attributedText = lastCommentAttributedText
        }else{
            lastCommentSeperator.hidden = true

            self.lastCommentTextView.text = "aa"
        }
    }
 

    

    static private func buildCommmentTextViewAttributedTextWithAuthorName(authorName: String?, commentTextContent: String?) -> NSAttributedString?{
        let attributedText = NSMutableAttributedString()
        
        // MARK:动态发布者名字
        if authorName != nil{
            let namePS = NSMutableParagraphStyle()
            namePS.lineSpacing = 2
            namePS.paragraphSpacing = 8
            attributedText.appendAttributedString(NSAttributedString(string:authorName!, attributes:[NSFontAttributeName:UIFont.systemFontOfSize(18), NSForegroundColorAttributeName:UIColor.blackColor(), NSParagraphStyleAttributeName:namePS]))
        }
        
        if commentTextContent?.isEmpty == false {
            if attributedText.length > 0 {
                attributedText.appendAttributedString(NSAttributedString(string: "\n"))
            }
            
            let contentPS = NSMutableParagraphStyle()
            contentPS.lineSpacing = 2
            contentPS.paragraphSpacing = 4
            attributedText.appendAttributedString(NSAttributedString(string:commentTextContent!, attributes:[NSFontAttributeName:UIFont.systemFontOfSize(14), NSForegroundColorAttributeName:UIColor.blackColor(), NSParagraphStyleAttributeName:contentPS]))
        }


        return attributedText
    }
    
    //calculate the height of the comment text
    static private func commentTextViewHeightWithAttributedText(attributedText:NSAttributedString?, commentTextViewWidth:CGFloat? = 0) ->CGFloat{
        if attributedText == nil {
            return 0
        }
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var sizingTextView : UITextView? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.sizingTextView = UITextView()
        }
        
        Static.sizingTextView?.attributedText = attributedText
        let sizingTextViewSize = Static.sizingTextView?.sizeThatFits(CGSizeMake(commentTextViewWidth!, CGFloat(MAXFLOAT)))
        return sizingTextViewSize!.height
    }
    
    //the SSCourseCellDelegate method
    func clickReplyButton(button: UIButton) {
        delegate?.commentCell!(self, didClickReplyButton: button)
    }
    
    func clickLikeButton(button: UIButton) {
        delegate?.commentCell!(self, didClickLikeButton: button)
    }
}

@objc protocol SSCourseCellDelegate {
    
    optional func commentCell(commentCell: SSCourseCell, didClickReplyButton: UIButton)
    optional func commentCell(commentCell: SSCourseCell, didClickLikeButton: UIButton)
}


let commentCellMinHeight: CGFloat = 64
let commentCellTopPadding: CGFloat = 6
let commentCellBottomPadding: CGFloat = 8

let commentTextVeiwTopMargin: CGFloat = 0

let lastCommentTextViewLittleThanCommentWidth: CGFloat = 22
let mainCommentTextViewLittleThanCellWidth: CGFloat = 66
let lastCommentShowViewTopMargin: CGFloat = 10


let commentCreateDateLabelTopMargin: CGFloat = 8
let commentCreateDateLabelBottomMargin: CGFloat = 0
let commentCreateDateLabelHeight: CGFloat = 21