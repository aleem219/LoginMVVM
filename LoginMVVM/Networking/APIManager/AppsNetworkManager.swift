//
//  AppsNetworkManager.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import Foundation
import UIKit
import AVFoundation
import MessageUI


// MARK: - Globle Variable for AppsNetworkManagerInstanse

let appsNetworkManagerInstanse = AppsNetworkManager.sharedInstanse
let iimageCache = NSCache<NSString, AnyObject>()
public typealias Parameters = [String: Any]

public class AppsNetworkManager: NSObject, MFMailComposeViewControllerDelegate {
    
    internal static let sharedInstanse: AppsNetworkManager = AppsNetworkManager()
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func requestApi(requestData: Data,
                    serviceurl: String,
                    showHud: Bool = true,
                    methodType: HttpMethod,
                    completionClosure: @escaping (_ result: Data) -> ()) -> Void {


        // Temporary: skip internet check in simulator
        #if targetEnvironment(simulator)
        // skip check
        #else
        if !InternetConnectionManager.isConnectedToNetwork() {
            DispatchQueue.main.async {
                UIViewController.getTopViewController()?.LoadingStop() // add this
                UIViewController.getTopViewController()?.showNoInternetAlert()
            }
            return
        }
        #endif

        DispatchQueue.main.async {
            UIViewController.getTopViewController()?.LoadingStart(msg: "Loading...")
        }
        // MARK: - Fetch URL From Strings
        guard let url = URL(string: serviceurl.replacingOccurrences(of: " ", with: "%20")) else { return }

        
        var request = URLRequest(url: url)
        var accessToken = ""
        if !UserDefaults.standard.getLoggedInAccessToken().isEmpty {
            accessToken = "Bearer \(UserDefaults.standard.getLoggedInAccessToken())"
        }
        print(accessToken)
    
        request.httpMethod = methodType.rawValue
        request.setValue(accessToken, forHTTPHeaderField: AppsNetworkManagerConstants.accessToken)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if methodType.rawValue != HttpMethod.get.rawValue {
            request.httpBody = requestData
        }

     
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                let returnMessage = "RequestFailed :-> \(String(describing: error!.localizedDescription))"
                DispatchQueue.main.async {
                    UIViewController.getTopViewController()?.LoadingStop() // add this
                    self.alert(message: returnMessage)
                }
                return
            }
            guard let httpsResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpsResponse.statusCode
            let json = self.nsdataToJSON(data: data ?? Data())
//            print("Response: \(json)")
            switch statusCode {
            case 200, 201:
                DispatchQueue.main.async {
                    print("Success Response: \(json ?? Data())")
                    UIViewController.getTopViewController()?.LoadingStop()
                    completionClosure(data ?? Data())
                }
            case 401:
                DispatchQueue.main.async {
                    let errorMessage = self.decodeErrorMessage(from: data)
                    print("Failure Response: \(json ?? Data())")
                    UIViewController
                        .getTopViewController()?
                        .showAlert(message: errorMessage)
                    completionClosure(data ?? Data())
                }
            case 402:
                let errorMessage = self.decodeErrorMessage(from: data)
                DispatchQueue.main.async {
                    print("unauthorized")
                    UIViewController
                        .getTopViewController()?
                        .showAlert(message: errorMessage)
                }
                
            default:
                DispatchQueue.main.async {
                    // Handle other cases
                    print("Response: \(String(describing: json))")
                    completionClosure(data ?? Data())
                    print("Unexpected status code: \(statusCode)")
                }
            }
        }.resume()
    }
    
    func requestMultipartApi(parameters : Dictionary<String , Any> , serviceurl:String , methodType:  HttpMethod, completionClosure: @escaping (_ result: Any?) -> ()) -> Void{
        let urlString = AppsNetworkManagerConstants.baseUrl + serviceurl
        guard let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20")) else { return }
        print("Connecting to Host with URL \(urlString) with parameters: \(parameters)")
        let accessToken = UserDefaults.standard.getLoggedInAccessToken()
        var request = URLRequest(url: url)
        print(accessToken)
        request.httpMethod = methodType.rawValue
        request.setValue(accessToken, forHTTPHeaderField: AppsNetworkManagerConstants.accessToken)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let boundary =  "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! createBody(parameters: parameters, boundary: boundary, mimeType: "image/jpeg/png/jpg/docx/doc/mp4/mov/movie/m4a")
        
        
        URLSession.shared.dataTask(with: request){(data , response , error) in
            guard error == nil else {
                let returnMessage = "RequestFailed :->  \(String(describing: error!.localizedDescription))"
                print(returnMessage)
                return
            }
            if let data = data {
                guard  let httpsresponse = response as? HTTPURLResponse else {return}
                
                let statusCode = httpsresponse.statusCode
               
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                   
                    print(response as Any)
                    
                    switch statusCode{
                    case 200 :
                        DispatchQueue.main.async {
                            completionClosure(response)
                        }
                        break
                    case 400:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            AlertController.showAlert(message: String.getString(kSharedInstance.getDictionary(data)["message"]))
                        }
                        break
                    case 401:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            AlertController.showAlert(message: String.getString(kSharedInstance.getDictionary(data)["message"]))
                        }
                        break
                    case 404:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            AlertController.showAlert(message: String.getString(kSharedInstance.getDictionary(data)["message"]))
                        }
                        break
                    case 409:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            AlertController.showAlert(message: String.getString(kSharedInstance.getDictionary(data)["message"]))
                        }
                        break

                    default:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            
                        }

                        break
                    }
                } catch {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    func createBody(parameters: [String: Any], boundary: String, mimeType: String) throws -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            if(value is String || value is NSString) {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            } else if let imagValue = value as? UIImage {
                let random = arc4random()
                let filename = "image\(random).jpg" //MARK:  put your imagename in key
                let data: Data = imagValue.jpegData(compressionQuality: 0.7) ?? Data()
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
                
            } else if value is [String: String] {
                var body1 = Data()
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                for (keyy, valuee) in (value as? [String: String])! {
                    body1.append("--\(boundary)\r\n")
                    body1.append("Content-Disposition: form-data; name=\"\(keyy)\"\r\n\r\n")
                    body1.append("\(valuee)\r\n")
                }
                
                body.append(body1)
                
            } else if let images = value as? [UIImage] {
                
                for image in images {
                    let random = arc4random()
                    let filename = "image\(random).jpg" //MARK:  put your imagename in key
                    let data: Data = image.jpegData(compressionQuality: 0.5)!
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                    
                }
            } else if let auidoData = value as? Data { //MARK:  it is Used for Video and pdf send to the server
                let random = arc4random()
                let filename = "\(key)\(random).m4a" //MARK:  Put you image Name in key
                let data : Data = auidoData
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: audio/m4a\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            } else if let videoData = value as? Data { //MARK:  it is Used for Video and pdf send to the server
                let random = arc4random()
                let filename = "\(key)\(random).mov" //MARK:  Put you image Name in key
                let data : Data = videoData
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            } else if let multipleData = value as? [Data] { //MARK:  It is used for Multiple Data to api
                for filedata in multipleData {
                    let random = arc4random()
                    let filename = "\(key)\(random).mov" //MARK:-  put your imagename in key
                    let data: Data = filedata
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                    
                }
            }
        }
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    
    func saveImageFromURL(imageUrl: String, imageName: String, folderName: String) {
        guard let url = URL(string: imageUrl.replacingOccurrences(of: " ", with: "%20")) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data for url: \(imageUrl)")
                return
            }
            
            self.saveImage(image: image, imageName: imageName, folderName: folderName)
            
        }.resume()
    }

    // MARK: - Save Image to Documents Directory
    private func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.jpegData(compressionQuality: 0.7),
              let path = getImagePath(imageName: imageName, folderName: folderName) else { return }
        
        do {
            try data.write(to: path)
            print("✅ Image saved at: \(path)")
        } catch {
            print("❌ Error saving image: \(error.localizedDescription)")
        }
    }

    // MARK: - Create Folder
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getFolderPath(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                print("📁 Folder created: \(folderName)")
            } catch {
                print("❌ Error creating folder: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Get Folder Path
    private func getFolderPath(folderName: String) -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }

    // MARK: - Get Image Path
    private func getImagePath(imageName: String, folderName: String) -> URL? {
        return getFolderPath(folderName: folderName)?
            .appendingPathComponent(imageName + ".jpg")
    }
}

//MARK:- Class For Shared Utilities For AppsNetworkManagerInstanse
extension AppsNetworkManager {
    
    //MARK: - Show Alert For Error
    func alert(message:String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(action1)
//        UIApplication.topViewController()?.present(alert , animated: true)
        
    }
    
    func nsdataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}


// MARK: - Constant for Api For Url Sessions

struct AppsNetworkManagerConstants {
    static let baseUrl                  = "https://dummyjson.com/auth"
    static let accessToken              = "Authorization"
}

// MARK: - Enum For httpsMethods

enum HttpMethod: String {
    case get  = "GET"
    case post = "POST"
    case put  = "PUT"
    case delete = "DELETE"
}

// MARK: - Extension for Downlode Image Using URl Sessions
extension UIImageView{
    
    private static var taskKey = 0
    private static var urlKey = 0
    
    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!
    
    static let shared = ImageCache()
    
    private init() {
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer as Any)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}


//MARK: - Extension for Downlode Image Using URl Sessions
extension UIImageView {
    
    //MARK:- Func for downlode image
    func downlodeImage(serviceurl:String , placeHolder: UIImage? = UIImage(named: "profilePlaceholder")) {
        
        self.image = placeHolder
        let urlString = serviceurl
        guard let url = URL(string: urlString.replacingOccurrences(of:  " ", with: "%20")) else { return }
        
        //MARK:- Check image Store in Cache or not
        if let cachedImage = iimageCache.object(forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString) {
            if  let image = cachedImage as? UIImage {
                self.image = image
                print("Find image on Cache : For Key" , urlString.replacingOccurrences(of: " ", with: "%20"))
                return
            }
        }
        
        print("Conecting to Host with Url:-> \(url)")
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    self.image = placeHolder
                    return
                }
            }
            if data == nil {
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    iimageCache.removeAllObjects()
                    self.image = image
                    iimageCache.setObject(image, forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString)
                }
            }
        }).resume()
    }
}

//MARK:- Extension of Data For Apped String
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
extension UserDefaults {
    func getLoggedInAccessToken() -> String {
        return string(forKey: "access_token") ?? ""
    }
}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "photo.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}


extension AppsNetworkManager {

    func decodeErrorMessage(from data: Data?) -> String {
        guard let data = data else {
            return "Something went wrong"
        }

        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponseModel.self, from: data)
            return errorResponse.message ?? "Something went wrong"
        } catch {
            print("❌ Error decoding ErrorResponseModel:", error)
            return "Something went wrong"
        }
    }
}
