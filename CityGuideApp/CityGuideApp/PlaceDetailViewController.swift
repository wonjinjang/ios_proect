import UIKit
import CoreLocation

class PlaceDetailViewController: UIViewController {
    var placeName: String?
    var placeType: String?
    var placeImageName: String?
    var placeDescription: String?
    var placeLatitude: Double?
    var placeLongitude: Double?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var visitSwitch: UISwitch!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var distanceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = placeName
        typeLabel.text = placeType
        descriptionLabel.text = placeDescription
        if let imageName = placeImageName {
            placeImageView.image = UIImage(named: imageName)
        }
        // 방문 체크 불러오기
        if let name = placeName {
            visitSwitch.isOn = UserDefaults.standard.bool(forKey: "visited_\(name)")
        }
        visitSwitch.addTarget(self, action: #selector(visitSwitchChanged), for: .valueChanged)
    }

    @objc func visitSwitchChanged() {
        if let name = placeName {
            UserDefaults.standard.set(visitSwitch.isOn, forKey: "visited_\(name)")
        }
    }

    @IBAction func calculateDistance(_ sender: Any) {
        guard let userLocation = locationTextField.text, !userLocation.isEmpty,
              let placeLat = placeLatitude, let placeLon = placeLongitude else {
            distanceLabel.text = "위치를 입력하세요."
            return
        }
        // 주소 → 좌표 변환 (CLGeocoder)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(userLocation) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let placemark = placemarks?.first, let userCoord = placemark.location?.coordinate {
                let userLoc = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
                let placeLoc = CLLocation(latitude: placeLat, longitude: placeLon)
                let distance = userLoc.distance(from: placeLoc) // meter
                let km = distance / 1000.0
                DispatchQueue.main.async {
                    self.distanceLabel.text = String(format: "거리: %.2f km", km)
                }
            } else {
                DispatchQueue.main.async {
                    self.distanceLabel.text = "위치 변환 실패"
                }
            }
        }
    }
} 
