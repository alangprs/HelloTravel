//
//  CategoryButton.swift
//  HelloTravel
//
//  Created by 翁燮羽 on 2023/3/17.
//

import UIKit

/// 圖上文字下按鈕
class CategoryButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCategory()
        setupBorder()
    }
    
    /// 修改圖片大小
    /// - Parameters:
    ///   - image: 要修改圖片
    ///   - targetSize: 設定大小
    /// - Returns: 修改完圖片
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        // 計算需要縮小的比例
        let scaleFactor = min(widthRatio, heightRatio)
        
        // 創建繪圖上下文
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        
        // 設置縮放比例
        let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        // 繪製圖像
        image.draw(in: CGRect(origin: CGPoint.zero, size: size).applying(transform))
        
        // 獲取調整大小後的圖像
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // 關閉繪圖上下文
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    /// 圖片、文字 位置設定
    private func setupCategory() {
        self.contentVerticalAlignment = .center
        
        self.titleEdgeInsets = UIEdgeInsets(top: self.imageView?.frame.size.height ?? 0, left: -(self.imageView?.frame.size.width ?? 0), bottom: -5, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -(self.imageView?.frame.size.height ?? 0), left: 0, bottom: 0, right: -(self.titleLabel?.bounds.size.width ?? 0))
        
        let imageViewHeight = imageView?.frame.size.height ?? 0
        let labelHeight = titleLabel?.frame.size.height ?? 0
        
        self.contentEdgeInsets = UIEdgeInsets(top: imageViewHeight, left: 0, bottom: labelHeight, right: 0)
        
        self.layer.cornerRadius = self.frame.height / 3
        self.backgroundColor = .white
        
    }

    /// 設定邊匡
    private func setupBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 5
    }
}


