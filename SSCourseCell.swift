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

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var lastCommentTextView: UITextView!
    @IBOutlet weak var sentTime: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
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

        replyButton.addTarget(self, action: #selector(SSCourseCell.clickReplyButton(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static func cellHeightWithData(data: AnyObject?, cellWidth: CGFloat) -> CGFloat{
        
        var cellHeight: CGFloat = 0
        
        let studentName = data?[""] as? String
        let textContent = data?[""] as? String
        let lastStudentName = data?[""] as? String
        let lastcomment = data?[""] as? String
        
        let commentTextViewWidth = cellWidth - mainCommentTextViewLittleThanCellWidth
        
        //set the main comment show view
        let commentAttributedText = SSCourseCell.buildCommmentTextViewAttributedTextWithAuthorName(studentName, commentTextContent: textContent)
        cellHeight += SSCourseCell.commentTextViewHeightWithAttributedText(commentAttributedText, commentTextViewWidth: commentTextViewWidth)
        
        
        cellHeight += lastCommentShowViewTopMargin
        
        
        //set the last comment show view
        if !(lastcomment!.isEmpty){
            let lastCommentSeperatorWidth = commentTextViewWidth - lastCommentTextViewLittleThanCommentWidth
            let lastCommentAttributedText = SSCourseCell.buildCommmentTextViewAttributedTextWithAuthorName(lastStudentName, commentTextContent: lastcomment)
            cellHeight += SSCourseCell.commentTextViewHeightWithAttributedText(lastCommentAttributedText, commentTextViewWidth: lastCommentSeperatorWidth)
        }
        
        //set the create date label
        cellHeight += (commentCreateDateLabelHeight + commentCreateDateLabelTopMargin + commentCreateDateLabelBottomMargin)
        
        //
        return cellHeight > commentCellMinHeight ? cellHeight : commentCellMinHeight
    }
    

    func configWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat = 0){
    
        let studentName = data?[""] as? String
        let textContent = data?[""] as? String
        let lastStudentName = data?[""] as? String
        let lastcomment = data?[""] as? String
        let createDate = data?[""]  as? NSDate

        
        let commentTextViewWidth = cellWidth - mainCommentTextViewLittleThanCellWidth
        
        // 设置文字内容
        let commentAttributedText = SSCourseCell.buildCommmentTextViewAttributedTextWithAuthorName(studentName, commentTextContent:textContent)
        commentTextViewHeightConstraint.constant = SSCourseCell.commentTextViewHeightWithAttributedText(commentAttributedText, commentTextViewWidth: commentTextViewWidth)
        
        // 设置时间
        if createDate != nil {
            //FIXME: set the date time with timestemp
//            sentTime?.text = MHPrettyDate.prettyDateFromDate(createDate, withFormat: MHPrettyDateFormatWithTime)
        } else {
            sentTime?.text = nil
        }
        
        //set the last comment show view
        if !(lastcomment!.isEmpty){
            let lastCommentSeperatorWidth = commentTextViewWidth - lastCommentTextViewLittleThanCommentWidth
            let lastCommentAttributedText = SSCourseCell.buildCommmentTextViewAttributedTextWithAuthorName(lastStudentName, commentTextContent: lastcomment)
            let limHeight:CGFloat = SSCourseCell.commentTextViewHeightWithAttributedText(lastCommentAttributedText, commentTextViewWidth: lastCommentSeperatorWidth)
            lastCommentTextViewHeightConstraint.constant = limHeight
            lastCommentShowViewHeightConstraint.constant = limHeight
            
        }

    }

    

    static private func buildCommmentTextViewAttributedTextWithAuthorName(authorName: String?, commentTextContent: String?) -> NSAttributedString?{
        let attributedText = NSMutableAttributedString()
        
        // 动态发布者名字
        if authorName?.isEmpty == false {
            let namePS = NSMutableParagraphStyle()
            namePS.lineSpacing = 2
            namePS.paragraphSpacing = 8
            attributedText.appendAttributedString(NSAttributedString(string:authorName!, attributes:[NSFontAttributeName:UIFont.systemFontOfSize(18), NSForegroundColorAttributeName:UIColor.blackColor(), NSParagraphStyleAttributeName:namePS]))
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
    func clickReplyButton(button: UIButton) {
        delegate?.commentCell(self, didClickReplyButton: button)
    }
}

protocol SSCourseCellDelegate {
    
    func commentCell(commentCell: SSCourseCell, didClickReplyButton: UIButton)
    
}


let commentCellMinHeight: CGFloat = 64
let commentCellTopPadding: CGFloat = 6
let commentCellBottomPadding: CGFloat = 8

let commentTextVeiwTopMargin: CGFloat = 0

let lastCommentTextViewLittleThanCommentWidth: CGFloat = 52
let mainCommentTextViewLittleThanCellWidth: CGFloat = 66
let lastCommentShowViewTopMargin: CGFloat = 7


let commentCreateDateLabelTopMargin: CGFloat = 8
let commentCreateDateLabelBottomMargin: CGFloat = 0
let commentCreateDateLabelHeight: CGFloat = 21