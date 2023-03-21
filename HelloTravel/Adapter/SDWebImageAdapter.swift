//
//  SDWebImageAdapter.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/21.
//

import UIKit
import SDWebImage

class SDWebImageAdapter {

    /// 使用套件設定圖片
    /// - Parameters:
    ///   - imageView: 要設定imageView
    ///   - imageString: 圖片位置字串
    func setImage(imageView: UIImageView, imageString: String) {
        imageView.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "testImage"))
    }
}
