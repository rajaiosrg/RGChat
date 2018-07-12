//
//  ConversationsCell.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import UIKit

class ConversationsCell: UITableViewCell {

    var avatarImageView : UIImageView!
    var nameLabel: UILabel!

    var imageSize : CGFloat = 40
    let imageLeftSpacing : CGFloat = 15
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let labelHeight: CGFloat = 24
        let selfHeight = self.frame.size.height
        let nameLeftSpacing : CGFloat = 10
        
        avatarImageView = UIImageView(frame: CGRect(x: imageLeftSpacing, y: (selfHeight - imageSize)/2, width: imageSize, height: imageSize))
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = imageSize/2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.image = UIImage (named: "ic_avatar")
        contentView.addSubview(avatarImageView)
        
        let lableMinX  = avatarImageView.frame.maxX + nameLeftSpacing
        let labelWidth: CGFloat = self.frame.width - (lableMinX)
        
        nameLabel = UILabel()
        nameLabel.frame = CGRect(x: lableMinX, y: (self.frame.height - labelHeight)/2, width: labelWidth, height: labelHeight)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(nameLabel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
