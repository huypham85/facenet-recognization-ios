
import UIKit
import AVFoundation
import SkyFloatingLabelTextField
import MBProgressHUD
import ProgressHUD

class AddNameViewController: BaseViewController {
    
    private var generator:AVAssetImageGenerator!
    
    @IBOutlet weak var idTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    var videoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        fnet.load()
        if let url = videoURL {
            self.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
                self.faceImageView.image = thumbImage
                self.faceImageView.layer.cornerRadius = self.faceImageView.frame.height / 2
            }
        }
        hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func tapDoneButoon(_ sender: UIButton) {
        ProgressHUD.show("Adding...")
        let getFrames = GetFrames()
        if let videoURL,
           let studentId = globalUser?.id,
           let currentFace = faceImageView.image
        {
            getFrames.getAllFrames(videoURL, for: studentId, currentFace: currentFace)
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}



