//
//  Cell.swift
//  newPhotoPicker
//
//  Created by Mesut Aygün on 17.06.2021.
//

import Foundation
import UIKit

class Cell : UICollectionViewCell {
  
     let imageView = UIImageView()
    
    override init(frame : CGRect){
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    }
