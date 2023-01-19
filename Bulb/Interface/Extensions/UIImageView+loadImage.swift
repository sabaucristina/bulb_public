//
//  UIImageView + loadImage.swift
//  Bulb
//
//  Created by Sabau Cristina on 08/11/2022.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadPlantIcon(imageURL: String) {
        self.contentMode = .center
        if let reference = FirestoreService.shared.createPlantImageRef(imageURL: imageURL) {
            self.contentMode = .scaleAspectFill
            self.sd_setImage(with: reference)
        } else {
            self.image = Image.plantIcon.uiImage
        }
    }

    func loadPlantImage(imageURL: String) {
        if let reference = FirestoreService.shared.createPlantImageRef(imageURL: imageURL) {
            self.sd_setImage(with: reference)
        } else {
            self.image = Image.defaultPlantImage.uiImage
        }
    }
}
