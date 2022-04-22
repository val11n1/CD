//
//  FriendCell.swift
//  facebookKiller
//
//  Created by Valeriy Trusov on 14.03.2022.
//

import Foundation
import UIKit

class MessageCell: BaseCellClass {
    
    var message: Message? {
        
        didSet {
            
            nameLabel.text = message?.friend?.name
            
            if let imageString = message?.friend?.profileImageName {
                
                profileImageView.image = UIImage(named: imageString)
                hasReadImageView.image = UIImage(named: imageString)
            }
            messageLabel.text = message?.text
            
            if let date = message?.date {
                
               let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                let elapsedTimeInSeconds = Date().timeIntervalSince(date)
                
                let secondInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > 7 * secondInDays {
                    
                    dateFormatter.dateFormat = "dd/MM/yy"
                    
                } else if elapsedTimeInSeconds > secondInDays {
                    
                    dateFormatter.dateFormat = "EEE"
                }
                
                timeLabel.text = dateFormatter.string(from: date)
            }
        }
    }
    
    let profileImageView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "morfContact1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    
    let dividerLineView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Morf undefeated"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Your friend's message and something else"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "12:05 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "morfContact1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 13
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        
        
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        addSubview(dividerLineView)
                NSLayoutConstraint.activate([
                    dividerLineView.topAnchor.constraint(equalTo: self.bottomAnchor),
                    dividerLineView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
                    dividerLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    dividerLineView.heightAnchor.constraint(equalToConstant: 1)
                ])
        setContainerView()
}
    
    override var isHighlighted: Bool {
        
        didSet {
            
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/250, alpha: 1.0): .white
            
            nameLabel.textColor = isHighlighted ? .white: .darkGray
            timeLabel.textColor = isHighlighted ? .white: .darkGray
            messageLabel.textColor = isHighlighted ? .white: .darkGray
        }
    }
    
    override func prepareForReuse() {
        
        
    }
    
    private func setContainerView() {
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
        
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        containerView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
        
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -15),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        containerView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
        
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -35),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            messageLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        containerView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
         
            timeLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            timeLabel.widthAnchor.constraint(equalToConstant: 80),
            timeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        containerView.addSubview(hasReadImageView)
        NSLayoutConstraint.activate([
        
            hasReadImageView.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
            hasReadImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            hasReadImageView.widthAnchor.constraint(equalToConstant: 26),
            hasReadImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}

class BaseCellClass: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
    }
}
