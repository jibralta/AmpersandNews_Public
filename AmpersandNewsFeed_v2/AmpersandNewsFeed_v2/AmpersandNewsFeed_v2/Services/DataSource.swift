//
//  DataSource.swift
//  AmpersandNewsFeed_v2
//
//  Created by Joy Umali on 3/5/18.
//  Copyright © 2018 Joy Umali. All rights reserved.
//

import UIKit

class DataSource {
    
    var imageCache = NSCache<AnyObject, AnyObject>()
    var activityIndicator = UIActivityIndicatorView()
    
    enum BackendError: Error {
        case urlError(reason: String)
        case objectsSerialization(reason: String)
    }
    
    func parseArticles(ofCategory category: String, completion: @escaping ([Article]) -> Void) {

//        DispatchQueue.global(qos: .userInteractive).async {
        
            let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=" + category + "&apiKey=ea22065a86a84832bd357ce90368684f"
            
            guard let url = URL(string: urlString) else { return }
        
        // TODO: close session
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data else { return }
                print(">>> line\(#line) URLSession DATA:", data) // prints in terms of bytes
                
                do {
                    let root = try JSONDecoder().decode(Root.self, from: data)
                    guard let articles = root.articles else { return }
                    
                    var articlesWithImgs = [Article]()
                    
                    for article in articles {
                        if article.urlToImage != nil {
                            articlesWithImgs.append(article)
                        } else {
                            print("!! got a null urlToImage for article: ", article)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(articlesWithImgs)
                        //                print("root:", root)
                        print("+++ # of articles:", articles.count)
                        print("+++ # ARTICLES:", articles)

                        print("+++ # of articlesWithImgs:", articlesWithImgs.count)
                    }
                    
                } catch let jsonErr {
                    print("!! error serializing json:", jsonErr, "\n")
                }

                } .resume()
        }

    var downloadImgTask: URLSessionDataTask?
    
    func cancelDownloadImg() {
        downloadImgTask?.cancel()
        downloadImgTask = nil
    }
    
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        
        // TODO: Cancel session
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage as? UIImage)
        } else {
            
            guard let imageURL = URL(string: url) else { return }
            let defaultSession = URLSession(configuration: .default)
            
            LoaderController.sharedInstance.showLoader()
            
            downloadImgTask = defaultSession.dataTask(with: imageURL) { data, response, error in
                if let e = error {
                    print("Error downloading image: ", e)
                } else {
                    
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded image with response code: ", res.statusCode)
                        DispatchQueue.global().async {

                        if let imageData = data {
                            DispatchQueue.main.async {
                                guard let originalImage = UIImage(data: imageData) else { return }
                                self.imageCache.setObject(originalImage, forKey: imageURL as AnyObject)
                                completion(originalImage)
                            }
                            
                            LoaderController.sharedInstance.removeLoader()
                            
                        } else {
                            print("No image retrieved. Image is nil.")
                        }
                    }
                        
                    } else {
                        print("Issue with response code.")
                    }
                }
            }
            downloadImgTask?.resume()
        }
    }
}






