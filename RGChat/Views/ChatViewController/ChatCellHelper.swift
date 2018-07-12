//
//  ChatCellHelper.swift
//  RGChat
//
//  Created by Raja Earla on 12/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation
import UIKit


class ChatCellHelper {

    var defaultCellHeight : CGFloat = 50
    var labelLeftSpacing : CGFloat = 15
    var bubbleViewMarginsSpacing : CGFloat = 20
    var cellsInterItemSpacing : CGFloat = 10

    
    func calculateCellHeight(viewModel : ChatViewModelProtocol) -> CGFloat{
        let message : String = viewModel.messageText
        
        let cellHeight = defaultCellHeight
        let sreenSize : CGRect = UIScreen.main.bounds
        let bubbleSize : CGSize = CGSize(width: sreenSize.width * 0.85, height: cellHeight * 0.85)
        
        let messageHeight : CGFloat = message.height(withConstrainedWidth: bubbleSize.width - labelLeftSpacing*2, font: UIFont.systemFont(ofSize: 16))
        
        return messageHeight + bubbleViewMarginsSpacing + cellsInterItemSpacing
    }
    
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
