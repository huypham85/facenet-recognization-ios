
import AVFoundation
import ProgressHUD
import UIKit

class FrameOperation: Operation {
    var time: Double!
    var label: String!
    private var generator: AVAssetImageGenerator!

    init(time: Double, label: String, gen: AVAssetImageGenerator) {
        self.time = time
        self.label = label
        generator = gen
    }

    override func main() {
        getFrame(fromTime: time, for: label)
    }

    private func getFrame(fromTime: Double, for label: String) {
        let time: CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 60)
        let image: UIImage
        do {
            try image = UIImage(cgImage: generator.copyCGImage(at: time, actualTime: nil))
        } catch {
            return
        }
        trainingDataset.saveImage(image, for: label)
        if let img = image.rotate(radians: .pi / 20) {
            trainingDataset.saveImage(img, for: label)
        }
        if let img = image.rotate(radians: -.pi / 20) {
            trainingDataset.saveImage(img, for: label)
        }
        if let img = image.flipHorizontally() {
            trainingDataset.saveImage(img, for: label)
        }
    }
}

class GetFrames {
    var fps = 2
    private var generator: AVAssetImageGenerator!

    func getAllFrames(_ videoUrl: URL, for label: String, currentFace: UIImage) {
        let asset = AVAsset(url: videoUrl)
        let duration: Double = CMTimeGetSeconds(asset.duration)
        generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10

        var i: Double = 0
        repeat {
            let frameOperation = FrameOperation(time: i, label: label, gen: generator)
            queue.addOperation(frameOperation)
            i = i + (1 / Double(fps))
        } while i < duration
        generator = nil
        queue.addBarrierBlock {
            print("Complete")
            ProgressHelper.showLoading(text: "Generating...")
            vectorHelper.addVector(name: label) { result in
                print("All vectors for \(label): \(result.count)")
                if result.count > 0 {
                    getKMeanVectorSameName(vectors: result) { vectors in
                        print("K-mean vector for \(label): \(vectors.count)")
                        firebaseManager.uploadKMeanVectors(vectors: vectors) {
                            firebaseManager.uploadAllVectors(vectors: result) {
                                if let studentId = globalUser?.id {
                                    firebaseManager.uploadCurrentFace(
                                        name: studentId,
                                        image: currentFace
                                    ) { error in
                                        if error != nil {
                                            print("upload current face error!")
                                        }
                                        ProgressHelper.hideLoading()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ProgressHelper.hideLoading()
                }
            }
        }
    }
}
