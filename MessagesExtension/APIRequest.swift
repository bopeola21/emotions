//
//  APIRequest.swift
//  EmotionRecognition
//
//  Created by Jide O on 11/19/16.
//  Copyright © 2016 Bevi Mobile. All rights reserved.
//

import UIKit

let endpointEmotions = "https://api.projectoxford.ai/emotion/v1.0/recognize"
let endpointImageRec = "https://api.projectoxford.ai/vision/v1.0/analyze?"
let visionsKey = "5224921031bf4088b1f32358935ac05e"
let emotionKey = "da0ce993b6464b168bcc0241b7b60091"

enum CameraType {
    case Front
    case Rear
}

class APIRequest: NSObject {
    
    class func fetchImageType(image: UIImage, completion:@escaping (_ text: [String]?)->()) {
        
        var url: URL?
        var key = ""
        
        if LibraryAPI.sharedInstance().cameraType == .Front {
            url = URL(string: endpointEmotions)
            key = emotionKey
        } else {
            let visualFeatures = "visualFeatures=Categories,Tags,Faces"
            url = URL(string: endpointImageRec + visualFeatures)
            key = visionsKey
        }

        
        // Base64 encode the image and create the request
        let imageBase64 = APIRequest.base64EncodeImage(image)
        // Create our request URL
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.addValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

        request.httpBody = imageBase64
        
        // Run the request on a background thread
        DispatchQueue.global().async {

            APIRequest.runRequestOnBackgroundThread(request, completion: { (text: [String]?) in
                completion(text)
            })
        
        }
    }

    class func base64EncodeImage(_ image: UIImage) -> Data {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = APIRequest.resizeImage(newSize, image: image)
        }
        
        return imagedata!
    }
    
    class func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    class func runRequestOnBackgroundThread(_ request: URLRequest, completion:@escaping (_ text: [String]?)->()) {
        // run the request
        let session = URLSession.shared

        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            let text = APIRequest.analyzeResults(data: data)
            
            completion(text)
        }
        
        task.resume()
    }
    
    class func analyzeResults(data: Data) -> [String]? {
        let json = JSON(data: data)
        var text: [String]?

        if LibraryAPI.sharedInstance().cameraType == .Front {
            let responses: JSON = json[0]

            if let scores = responses["scores"].dictionaryObject {
                var score = 0.0
                
                for (key,value) in scores {
                    let val = value as! Double

                    if val > score {
                        score = val
                        text = [key]
                    }
                }
            }
        } else {
            if let responses = json["tags"].array {
                text = [String]()
                for objectArray in responses {
                    if let objectDict = objectArray.dictionaryObject {

                        if let object = objectDict["name"] as? String {

                            text?.append(object)
                        }
                    }
                }
            }

        }
      //  print(json)
        return text
        
       // let errorObj: JSON = json["error"]
        
    }

}
