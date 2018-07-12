//
//  ChatTableViewCell.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    var messageLabel : UILabel!
    var bubbleView : UIView!

    let labelHeight: CGFloat = 24
    let minYOffSet : CGFloat = 5
    let nameLeftSpacing : CGFloat = 10
    
    var messageTextLableLeftSpacing : CGFloat = 15
        var bubbleViewExtraSpacing : CGFloat = 20
    var isIncomingMessage : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bubbleView = UIView()
        contentView.addSubview(bubbleView)
        
        messageLabel = UILabel()
        messageLabel.textColor = UIColor.black
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        bubbleView.addSubview(messageLabel)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        
    }
    
    func renderLayout() {
        
        let messageString : String = messageLabel.text!
        
        let cellHeight = self.contentView.frame.size.height
        let sreenSize : CGRect = UIScreen.main.bounds
        let bubbleSize : CGSize = CGSize(width: sreenSize.width * 0.85, height: cellHeight * 0.85)
        let bubbleViewMinX = self.isIncomingMessage ? 5 : (sreenSize.width - bubbleSize.width) - 5
        
        let messageHeight : CGFloat = messageString.height(withConstrainedWidth: bubbleSize.width - messageTextLableLeftSpacing*2, font: messageLabel.font)
        
        bubbleView.layer.cornerRadius = bubbleSize.height/2
        bubbleView.layer.masksToBounds = true
        
        if self.isIncomingMessage {
            bubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
            bubbleView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: bubbleViewMinX).isActive = true
            bubbleView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -(sreenSize.width - bubbleSize.width) - 5).isActive = true
            bubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
            
            bubbleView.heightAnchor.constraint(equalToConstant: messageHeight + bubbleViewExtraSpacing).isActive = true
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
            messageLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: messageTextLableLeftSpacing).isActive = true
            messageLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: messageTextLableLeftSpacing).isActive = true
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0).isActive = true
            
        } else {
            bubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
            bubbleView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: bubbleViewMinX).isActive = true
            bubbleView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5).isActive = true
            bubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
            
            bubbleView.heightAnchor.constraint(equalToConstant: messageHeight + bubbleViewExtraSpacing).isActive = true
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
            messageLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: messageTextLableLeftSpacing).isActive = true
            messageLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -messageTextLableLeftSpacing).isActive = true
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0).isActive = true
            
        }
    }
    
    func updateFrames() {

    }
    
    func bindWithViewModel(viewModel : ChatViewModelProtocol)  {

    }
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
