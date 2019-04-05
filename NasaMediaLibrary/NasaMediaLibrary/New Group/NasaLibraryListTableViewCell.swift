//
//  NasaLibraryListTableViewCell.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/2/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class NasaLibraryListTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var nasaImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        nasaImage.createRoundedBorder()
        self.contentView.backgroundColor = Constants.backgroundColor
    }
    
    func configure(at index:Int, viewModel:NasaMediaLibraryViewModel?) {
        if let viewModel = viewModel {
            guard let titleString = viewModel.getTitle(at:index) else {
                return
            }
            title.text = titleString
            title.isHidden = false
            
            guard let dateString = viewModel.getDate(at:index) else {
                return
            }
            location.text = dateString
            location.isHidden = false
            
            guard let imageURL = viewModel.getImageURL(at: index) else {
                return
            }
            
            DispatchQueue.global(qos:.background).async {
                
                if let url = URL(string:imageURL){
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async { [weak self] in
                            // once we have the data go back to main thread and load the image view
                            self?.nasaImage.image = UIImage(data: data)
                            self?.spinner.stopAnimating()
                        }
                    }
                }
            }
          
        } else {
            title.isHidden = true
            location.isHidden = true
            nasaImage.isHidden = true
            spinner.startAnimating()
        }
    }
}
