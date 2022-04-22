//
//  ChatLogCell.swift
//  facebookKiller
//
//  Created by Valeriy Trusov on 15.03.2022.
//

import UIKit

class ChatLogCell: BaseCellClass {
    
    let messageTextView: UITextView = {
        
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Simple message"
        textView.backgroundColor = .clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        
        let view = UIView()
        //view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        
        
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    static let blueBubbleImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = ChatLogCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.80, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
        
    override func setupViews() {
        super.setupViews()
        
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
        textBubbleView.addSubview(bubbleImageView)
        NSLayoutConstraint.activate([
            
            bubbleImageView.leadingAnchor.constraint(equalTo:textBubbleView.leadingAnchor),
            bubbleImageView.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor),
            bubbleImageView.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor),
            bubbleImageView.topAnchor.constraint(equalTo: textBubbleView.topAnchor)
        ])
    }
}
