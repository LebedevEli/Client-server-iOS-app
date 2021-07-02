//
//  UIImageView + load URL.swift
//  vk-api
//
//  Created by Илья Лебедев on 01.07.2021.
//

import UIKit
//загрузка картинок по URL
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
