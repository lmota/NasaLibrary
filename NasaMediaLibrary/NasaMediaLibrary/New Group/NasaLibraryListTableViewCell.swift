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
    
    func configure(with model:NasaMediaLibraryCollectionItem?) {
        if let model = model {
            guard let mediaLibraryData = model.mediaLibraryModels.first else {
                return
            }
            title.text = mediaLibraryData.title // fetch from model
            title.isHidden = false
            
            if let formattedDate = mediaLibraryData.date.getFormattedDate(){
                location.text = formattedDate
            }
            location.isHidden = false
            
            guard let mediaLibraryItemLink = model.links.first else {
                return
            }
            
            DispatchQueue.global(qos:.background).async {
                
                if let url = URL(string:mediaLibraryItemLink.href){
                    if let data = try? Data(contentsOf: url) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        
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
