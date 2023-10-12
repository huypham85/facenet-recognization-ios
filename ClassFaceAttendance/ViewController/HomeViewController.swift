
import UIKit
import AVFoundation
import RealmSwift
import ProgressHUD
//import KDTree


class HomeViewController: BaseViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var vectorsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if !NetworkChecker.isConnectedToInternet {
            showDialog(message: "You have not connected to internet. Using local data.")
        }
        checkUserRole()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        if let i = current {
            img.image  = UIImage(cgImage: i)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        fnet.clean()
        //loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
        fnet.load()
        
        
        
    }
    
    @IBAction func tapStart(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startPredict", sender: nil)
    }
    @IBAction func tapPredictImage(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openPredictImage", sender: nil)
    }
    @IBAction func tapAddUser(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openAddUser", sender: nil)
    }
    @IBAction func tapViewData(_ sender: UIButton) {
        self.performSegue(withIdentifier: "viewFace", sender: nil)
    }
    @IBAction func tapViewLog(_ sender: UIButton) {
        self.performSegue(withIdentifier: "viewLog", sender: nil)
    }
    @IBAction func logOut(_ sender: Any) {
        firebaseManager.logOut()
        firebaseManager.hasLogInSession {
            if !$0 {
                Application.shared.changeRootViewMainWindow(viewController: LoginViewController.create(),animated: true)
            }
        }
    }
    @IBAction func tapSyncData(_ sender: UIButton) {
        loadData()
        if !NetworkChecker.isConnectedToInternet {
            showDialog(message: "You have not connected to internet. Using local data.")
            ProgressHUD.dismiss()
        }
    }
    
    private func checkUserRole() {
        firebaseManager.checkUserRole { role in
            switch role {
            case .student:
                break
            case .teacher:
                break
            }
        }
    }
    
    func loadData() {
        if NetworkChecker.isConnectedToInternet {
            ProgressHUD.show("Loading users...")
            firebaseManager.loadVector { [self] (result) in
                kMeanVectors = result
                print("Number of k-Means vectors: \(kMeanVectors.count)")
                vectorsLabel.text = "You have \(kMeanVectors.count / NUMBER_OF_K) users."
                //tree = KDTree(values: kMeanVectors)
                ProgressHUD.dismiss()
                
                //save to local data
                try! realm.write {
                    realm.deleteAll()
                }
                for vector in kMeanVectors {
                    vectorHelper.saveVector(vector)
                }
            }
            
            //            fb.loadLogTimes { (result) in
            //                attendList = result
            //                for user in attendList {
            //                    let u = User(name: user.name, image: UIImage(named: "LaunchImage")!, time: user.time)
            //                    localUserList.append(u)
            //                }
            //            }
//            firebaseManager.loadUsers(completionHandler: { (result) in
//                userDict = result
//                print("Number of users: \(userDict.count)")
//                ProgressHUD.dismiss()
//            })
            
        }
        else {
            //for local data
            let result = realm.objects(SavedVector.self)
            print(result.count)
            kMeanVectors = []
            for vector in result {
                let v = Vector(name: vector.name, vector: stringToArray(string: vector.vector), distance: vector.distance)
                kMeanVectors.append(v)
            }
            vectorsLabel.text = "You have \(kMeanVectors.count / NUMBER_OF_K) users."
        }
    }
    
}

extension HomeViewController {
    static func create() -> HomeViewController {
        let viewController = HomeViewController.loadStoryboard(.main)
        return viewController
    }
}

