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
        self.contentView.backgroundColor = Constants.backgroundColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with viewModel:NasaMediaLibraryDetailViewModel?) {
        if let viewModel = viewModel {
            
            detailTitleLabel.isHidden = false
            detailDescriptionTextView.isHidden = false
            nasaDetailImageView.isHidden = false
            detailDateLabel.isHidden = false
            
            if let detailTitle = viewModel.getTitle(){
                detailTitleLabel.text = detailTitle
            }

            if let detailDate = viewModel.getDate(){
                detailDateLabel.text = detailDate
            }
            
            if let detailDescription = viewModel.getDescription(){
                detailDescriptionTextView.text = detailDescription
            }
            
            guard let imageURL = viewModel.getImageURL() else {
                return
            }
            
            DispatchQueue.global(qos:.background).async {
                
                if let url = URL(string:imageURL){
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
