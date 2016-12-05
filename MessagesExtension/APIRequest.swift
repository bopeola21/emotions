//
//  APIRequest.swift
//  EmotionRecognition
//
//  Created by Jide O on 11/19/16.
//  Copyright © 2016 Bevi Mobile. All rights reserved.
//

import UIKit

let endpoint = "https://api.projectoxford.ai/emotion/v1.0/recognize"

class APIRequest: NSObject {
    
    class func fetchEmotion(image: UIImage) {

        // Base64 encode the image and create the request
        let imageBase64 = APIRequest.base64EncodeImage(image)
        // Create our request URL
        
        var url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("da0ce993b6464b168bcc0241b7b60091", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        
        let dict = ["url" : "http://xdesktopwallpapers.com/wp-content/uploads/2011/08/Aarti-Chhabria-Smiling-Face-Cute-Eyes.jpg"]
        
//        var requestData = NSData()
//        do {
//            requestData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0)) as NSData
//            
//        } catch {
//           print("error")
//        }
//        let jsonString = NSString(data: requestData as Data, encoding: String.Encoding.utf8.rawValue)
//        let postData = jsonString?.data(using: String.Encoding.ascii.rawValue, allowLossyConversion: true)
//        
//        

        let jsonObject = JSON(jsonDictionary: dict)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { APIRequest.runRequestOnBackgroundThread(request) }
        
        
        
        
//        let imageData = UIImagePNGRepresentation(image)! as Data
//
//
//        
//        let paramString = "http://xdesktopwallpapers.com/wp-content/uploads/2011/08/Aarti-Chhabria-Smiling-Face-Cute-Eyes.jpg"

            
    }
    
    class func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = APIRequest.resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    class func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    class func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        let session = URLSession.shared

        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            print(data)
            print(response)
            
            let json = JSON(data: data)
            let errorObj: JSON = json["error"]
            print(json)
            
           // self.analyzeResults(data)
        }
        
        task.resume()
    }

}
