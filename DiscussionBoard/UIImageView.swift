//
//  UIImageView.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 16/1/2564 BE.
//

import Alamofire
import SDWebImage

//let imageCache = SDImageCache(namespace: "SDimageCache")

extension UIImageView {
    // MARK: Public methods
    
    /**
     Make layer of UIImageView to be circle (use height)
     */
    
    func setTintWith(color: UIColor) {
        if let _ = self.image {
            self.image? = (self.image?.withRenderingMode(.alwaysTemplate))!
            self.tintColor = color
        }
    }
    
    func render(_ image: UIImage, withColor color: UIColor) {
        self.image = image
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func setRounded() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    /**
     Load image from url string use Alamofire 4.0 Framework
     
     - parameter urlConvertible: url string, URL Class (from Alamofire)
     - parameter placeholderImage: UIImage
     - completionHandler completion: UIImage output
     */
    
    func setLoadImage(_ urlString: String, placeholderImage: UIImage?) {
        guard let url = URL(string: urlString) else {
            self.image = placeholderImage
            return
        }
        let phImg = placeholderImage
        
        sd_setImage(with: url, placeholderImage: phImg, options: [.progressiveLoad], progress: { (p1:Int, p2:Int, url: URL?) in
            //progress
        }) { (image:UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
            
        }
        
        
    }
    
    func setImage(_ urlString: String, placeholderImage: UIImage?, completion :((_ image: UIImage) -> Void)? = nil) {
        
        guard let url = URL(string: urlString) else {
            self.image = placeholderImage
            return
        }
        
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: [.progressiveLoad], progress: { (receivedSize, expectedSize, url) in
            
        }) { (image, error, type, url) in
            if let img = image {
                completion?(img)
            }
        }
    }
    
    func setRandomDownloadImage(_ width: Int, height: Int) {
        if self.image != nil {
            self.alpha = 1
            return
        }
        self.alpha = 0
        let url = URL(string: "http://lorempixel.com/\(width)/\(height)/")!
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode / 100 != 2 {
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.alpha = 1
                            }, completion: { (finished: Bool) -> Void in
                        })
                    })
                }
            }
        }
        task.resume()
    }
    
    func shadow(_ radius: CGFloat, opacity: CGFloat, intensity: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowOffset = CGSize(width: intensity, height: intensity)
        self.layer.shadowRadius = radius
    }
    
    func circle() {
        self.layer.cornerRadius = self.frame.size.height / 2;
    }
}
