import UIKit
import AVKit
import PhotosUI

typealias PermissionStatus = (_ status: Int, _ isGranted: Bool)-> ()

class PermissionManager {
    
    static var shared = PermissionManager()
    
    var popupWindow: UIWindow?
    var popupViewController: UIViewController?
    var cameraPermission: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    var photoPermission: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    let locationManager = CLLocationManager()
    var locationPermissionStatus: CLAuthorizationStatus {
      return CLLocationManager.authorizationStatus()
    }
    
    private init() {}
}

// MARK: - UI method(s)
extension PermissionManager {
    
    func showPopup(title: String, message: String) {
        DispatchQueue.main.async {
            guard let windowScene = App.application.connectedScenes.filter({ $0.activationState == .foregroundActive }).first as? UIWindowScene else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionSettings = UIAlertAction(title: "Settings", style: .default) {[weak self] (_) in
                guard let weakSelf = self else { return }
                if let url = URL(string: UIApplication.openSettingsURLString), App.application.canOpenURL(url) {
                    App.application.open(url, options: [:], completionHandler: nil)
                }
                weakSelf.popupWindow?.resignKey()
                weakSelf.popupWindow = nil
                weakSelf.popupViewController = nil
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) {[weak self] (_) in
                guard let weakSelf = self else { return }
                weakSelf.popupWindow?.resignKey()
                weakSelf.popupWindow = nil
                weakSelf.popupViewController = nil
            }
            alert.addAction(actionSettings)
            alert.addAction(actionCancel)
            self.popupWindow = UIWindow(windowScene: windowScene)
            self.popupViewController = UIViewController()
            self.popupViewController?.view.backgroundColor = .clear
            self.popupWindow?.rootViewController = self.popupViewController
            self.popupWindow?.makeKeyAndVisible()
            self.popupWindow?.backgroundColor = .clear
            self.popupViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Permsission requests
extension PermissionManager {
    
    func requestCameraPermission(completion: PermissionStatus?) {
        switch cameraPermission {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {[weak self] (isGranted) in
                guard let weakSelf = self else { return }
                if isGranted {
                    completion?(AVAuthorizationStatus.authorized.rawValue, true)
                } else {
                    completion?(AVAuthorizationStatus.denied.rawValue, false)
                    weakSelf.showPopup(title: kNoCameraTitle, message: kNoCameraMessage)
                }
            }
        case .authorized:
            completion?(AVAuthorizationStatus.authorized.rawValue, true)
        case .denied:
            completion?(AVAuthorizationStatus.denied.rawValue, false)
            showPopup(title: kNoCameraTitle, message: kNoCameraMessage)
        case .restricted:
            completion?(AVAuthorizationStatus.restricted.rawValue, false)
        @unknown default:
            completion?(-1, false)
        }
    }
    
    func requestPhotoPermission(completion: PermissionStatus?) {
        switch photoPermission {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization {[weak self] (status) in
                guard let weakSelf = self else { return }
                if status == .authorized {
                    completion?(PHAuthorizationStatus.authorized.rawValue, true)
                } else {
                    completion?(PHAuthorizationStatus.denied.rawValue, false)
                    weakSelf.showPopup(title: kNoPhotoTitle, message: kNoPhotoMessage)
                }
            }
        case .authorized:
            completion?(PHAuthorizationStatus.authorized.rawValue, true)
        case .denied:
            completion?(PHAuthorizationStatus.denied.rawValue, false)
            showPopup(title: kNoPhotoTitle, message: kNoPhotoMessage)
        case .restricted:
            completion?(PHAuthorizationStatus.restricted.rawValue, false)
        @unknown default:
            completion?(-1, false)
        }
    }
    
    func requestForLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}
