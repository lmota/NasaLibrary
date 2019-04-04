//
//  NasaLibraryDetailTableViewCell.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/2/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class NasaLibraryDetailTableViewCell: UITableViewCell {

 
    @IBOutlet weak var nasaDetailImageView: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailDescriptionTextView: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nasaDetailImageView.createRoundedBorder()
        detailDescriptionTextView.backgroundColor = .clear
        detailDescriptionTextView.textColor = .black
        self.contentView.backgroundColor = UIColor(red:0.925, green: 1.0, blue: 1.0, alpha: 1)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with model:NasaMediaLibraryCollectionItem?) {
        if let model = model {
            
            detailTitleLabel.isHidden = false
            detailDescriptionTextView.isHidden = false
            nasaDetailImageView.isHidden = false
            detailDateLabel.isHidden = false
            
            guard let mediaLibraryData = model.mediaLibraryModels.first else
            {
                return
            }
            
            detailTitleLabel.text = mediaLibraryData.title

            if let formattedDate = mediaLibraryData.date.getFormattedDate(){
                detailDateLabel.text = formattedDate
            }
            detailDescriptionTextView.text = mediaLibraryData.description
            
            guard let mediaLibraryItemLink = model.links.first else
            {
                return
            }
            
            DispatchQueue.global(qos:.background).async {
                
                if let url = URL(string:mediaLibraryItemLink.href){
                    if let data = try? Data(contentsOf: url) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.nasaDetailImageView.image = UIImage(data: data)
                            self?.spinner.stopAnimating()
                        }
                        
                    }
                }
                
            }
            
        } else {
            detailTitleLabel.isHidden = true
            detailDescriptionTextView.isHidden = true
            nasaDetailImageView.isHidden = true
            detailDateLabel.isHidden = true
            self.spinner.startAnimating()
        }
    }
}
