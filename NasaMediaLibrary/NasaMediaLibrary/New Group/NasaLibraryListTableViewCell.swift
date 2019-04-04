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
        self.contentView.backgroundColor = UIColor(red:0.925, green: 1.0, blue: 1.0, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model:NasaMediaLibraryCollectionItem?) {
        if let model = model {
            guard let mediaLibraryData = model.mediaLibraryModels.first else
            {
                return
            }
            title.text = mediaLibraryData.title // fetch from model
            title.alpha = 1
            
            if let formattedDate = mediaLibraryData.date.getFormattedDate(){
                location.text = formattedDate
            }
            
            location.alpha = 1
            
            guard let mediaLibraryItemLink = model.links.first else
            {
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

extension String{
    
    func getFormattedDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterNew = DateFormatter()
        dateFormatterNew.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatterNew.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: self){
            return dateFormatterNew.string(from: date)
        }
        
        return nil
    }
    
}

extension UIImageView {
    
    func createRoundedBorder(){
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
    }
    
}
