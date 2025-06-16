import UIKit
import CoreLocation

class PlaceDetailViewController: UIViewController {
    // MARK: - Data
    var placeName: String?
    var placeType: String?
    var placeImageName: String?
    var placeDescription: String?
    var placeLatitude: Double?
    var placeLongitude: Double?
    var placeAddress: String?
    var placeOpenTime: String?
    var placeSiteURL: String?
    var isVisited: Bool = false
    var isFavorite: Bool = false
    // 내 위치를 관악구 관악드림타운(37.4802, 126.9527)으로 고정
    let fixedUserLocation = CLLocation(latitude: 37.4802, longitude: 126.9527)

    // MARK: - Outlets
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var visitButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var siteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        nameLabel.text = placeName
        addressLabel.text = placeAddress ?? "주소 정보 없음"
        openTimeLabel.text = placeOpenTime ?? "정보 없음"
        visitButton.setTitle(isVisited ? "O" : "X", for: .normal)
        // 즐겨찾기 버튼: 비어있는 별(☆), 채워진 별(★, 노란색)
        updateFavoriteButton()
        descriptionTitleLabel.text = "Description"
        descriptionLabel.text = placeDescription
        distanceTitleLabel.text = "내 위치로부터 거리:"
        if let imageName = placeImageName {
            placeImageView.image = UIImage(named: imageName)
        }
        // 거리 계산: 내 위치(관악드림타운) 기준
        if let lat = placeLatitude, let lon = placeLongitude {
            let placeLoc = CLLocation(latitude: lat, longitude: lon)
            let distance = fixedUserLocation.distance(from: placeLoc) / 1000.0
            distanceLabel.text = String(format: "%.2f km", distance)
        } else {
            distanceLabel.text = "알 수 없음"
        }
        siteButton.setTitle("사이트 방문하기", for: .normal)
    }

    func updateFavoriteButton() {
        if isFavorite {
            // 채워진 노란 별 (SF Symbol: star.fill, tintColor: systemYellow)
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favoriteButton.tintColor = .systemYellow
        } else {
            // 비어있는 별 (SF Symbol: star, tintColor: systemGray)
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            favoriteButton.tintColor = .systemGray
        }
    }

    @IBAction func visitButtonTapped(_ sender: UIButton) {
        isVisited.toggle()
        visitButton.setTitle(isVisited ? "O" : "X", for: .normal)
        if let name = placeName {
            UserDefaults.standard.set(isVisited, forKey: "visited_\(name)")
        }
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        isFavorite.toggle()
        updateFavoriteButton()
        if let name = placeName {
            UserDefaults.standard.set(isFavorite, forKey: "favorite_\(name)")
        }
    }

    @IBAction func siteButtonTapped(_ sender: UIButton) {
        guard let urlString = placeSiteURL, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            let alert = UIAlertController(title: "오류", message: "유효하지 않은 사이트 주소입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        UIApplication.shared.open(url)
    }
} 
