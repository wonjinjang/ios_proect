import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var myLocationButton: UIButton!

    let locationManager = CLLocationManager()

    let cities = [
        ("서울", 37.5665, 126.9780),
        ("부산", 35.1796, 129.0756),
        ("대구", 35.8722, 128.6025)
    ]

    struct Place {
        let name: String
        let latitude: Double
        let longitude: Double
        let type: PlaceType
        let imageName: String
        let description: String
        enum PlaceType {
            case attraction
            case restaurant
        }
    }

    let placesByCity: [[Place]] = [
        [
            Place(name: "N서울타워", latitude: 37.5512, longitude: 126.9882, type: .attraction, imageName: "nseoultower.jpg", description: "서울을 한눈에 볼 수 있는 대표 전망대."),
            Place(name: "경복궁", latitude: 37.5796, longitude: 126.9770, type: .attraction, imageName: "gyeongbokgung.jpg", description: "조선시대의 대표 궁궐."),
            Place(name: "진옥화할매닭발", latitude: 37.5702, longitude: 126.9910, type: .restaurant, imageName: "jinokhwa.jpg", description: "매운 닭발로 유명한 맛집.")
        ],
        [
            Place(name: "해운대 해수욕장", latitude: 35.1587, longitude: 129.1604, type: .attraction, imageName: "haeundae.jpg", description: "부산의 대표 해변."),
            Place(name: "광안대교", latitude: 35.1532, longitude: 129.1186, type: .attraction, imageName: "gwangan.jpg", description: "야경이 아름다운 대교."),
            Place(name: "돼지국밥집", latitude: 35.1645, longitude: 129.0724, type: .restaurant, imageName: "porkgukbap.jpg", description: "부산의 명물 돼지국밥 맛집.")
        ],
        [
            Place(name: "동성로", latitude: 35.8695, longitude: 128.5945, type: .attraction, imageName: "dongseongro.jpg", description: "대구의 번화가."),
            Place(name: "이월드", latitude: 35.8532, longitude: 128.5668, type: .attraction, imageName: "eworld.jpg", description: "대구의 놀이공원."),
            Place(name: "막창골목", latitude: 35.8700, longitude: 128.5940, type: .restaurant, imageName: "makchang.jpg", description: "막창으로 유명한 골목.")
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        let coordinate = CLLocationCoordinate2D(latitude: cities[0].1, longitude: cities[0].2)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: false)
        filterSegmentedControl.selectedSegmentIndex = 0
        updateAnnotations()
    }

    @IBAction func moveToMyLocation(_ sender: UIButton) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("서울 관악구 성현로80") { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first, let coord = placemark.location?.coordinate else { return }
            let region = MKCoordinateRegion(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(region, animated: true)
            // 기존 "내 위치" 마커 제거
            self.mapView.annotations
                .filter { $0.title == "내 위치" }
                .forEach { self.mapView.removeAnnotation($0) }
            // 파란색 마커 추가
            let annotation = MKPointAnnotation()
            annotation.title = "내 위치"
            annotation.coordinate = coord
            self.mapView.addAnnotation(annotation)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let selectedIndex = UserDefaults.standard.integer(forKey: "SelectedCityIndex")
        let city = cities[selectedIndex]
        let coordinate = CLLocationCoordinate2D(latitude: city.1, longitude: city.2)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: false)
        updateAnnotations()
    }

    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        updateAnnotations()
    }

    func updateAnnotations() {
        let selectedIndex = UserDefaults.standard.integer(forKey: "SelectedCityIndex")
        let places = placesByCity[selectedIndex]
        let filter = filterSegmentedControl.selectedSegmentIndex // 0: 전체, 1: 방문, 2: 미방문
        mapView.removeAnnotations(mapView.annotations)
        for place in places {
            let visited = UserDefaults.standard.bool(forKey: "visited_\(place.name)")
            if filter == 1 && !visited { continue }
            if filter == 2 && visited { continue }
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            mapView.addAnnotation(annotation)
        }
    }

    // 마커 클릭 시 상세 정보 화면으로 이동
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        let selectedIndex = UserDefaults.standard.integer(forKey: "SelectedCityIndex")
        let places = placesByCity[selectedIndex]
        if let place = places.first(where: { $0.name == annotation.title }) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier:   "PlaceDetailViewController") as? PlaceDetailViewController {
                detailVC.placeName = place.name
                detailVC.placeType = (place.type == .attraction) ? "관광지" : "맛집"
                detailVC.placeImageName = place.imageName
                detailVC.placeDescription = place.description
                detailVC.placeLatitude = place.latitude
                detailVC.placeLongitude = place.longitude
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }

    // 마커 색상 커스텀
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title == "내 위치" {
            let identifier = "UserLocation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.pinTintColor = .systemBlue
            return annotationView
        }
        guard !(annotation is MKUserLocation) else { return nil }
        let identifier = "PlaceAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        // 타입별 색상 지정
        let selectedIndex = UserDefaults.standard.integer(forKey: "SelectedCityIndex")
        let places = placesByCity[selectedIndex]
        if let place = places.first(where: { $0.name == annotation.title }) {
            annotationView?.pinTintColor = (place.type == .attraction) ? .systemBlue : .systemRed
        } else {
            annotationView?.pinTintColor = .systemGray
        }
        return annotationView
    }
}
