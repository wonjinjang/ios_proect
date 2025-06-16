import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var favoritesTableView: UITableView!

    let locationManager = CLLocationManager()

    struct Place: Codable {
        let city: String
        let name: String
        let type: String
        let latitude: Double
        let longitude: Double
        let description: String
        let image: String
        let address: String
        let openTime: String
        let siteURL: String
    }

    var allPlaces: [Place] = []
    var filteredPlaces: [Place] = []
    var favoritePlaces: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        filterSegmentedControl.selectedSegmentIndex = 0
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.isHidden = true
        loadPlacesFromJSON()
        updateForSelectedDistrict()
    }

    func loadPlacesFromJSON() {
        if let url = Bundle.main.url(forResource: "placeData", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let places = try? decoder.decode([Place].self, from: data) {
                allPlaces = places
            }
        }
    }

    func updateForSelectedDistrict() {
        let selectedIndex = UserDefaults.standard.integer(forKey: "SelectedDistrictIndex")
        let districts = ["관악구", "강남구", "동작구", "금천구", "영등포구", "용산구", "성북구"]
        let selectedDistrict = districts[selectedIndex]
        filteredPlaces = allPlaces.filter { $0.city == "서울" && $0.address.contains(selectedDistrict) }
        // 지도 중심을 해당 구의 첫 번째 장소로 이동
        if let first = filteredPlaces.first {
            let coord = CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude)
            let region = MKCoordinateRegion(center: coord, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: false)
        }
        updateAnnotations()
    }

    @IBAction func moveToMyLocation(_ sender: UIButton) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("서울 관악구 성현로80") { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first, let coord = placemark.location?.coordinate else { return }
            let region = MKCoordinateRegion(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(region, animated: true)
            self.mapView.annotations
                .filter { $0.title == "내 위치" }
                .forEach { self.mapView.removeAnnotation($0) }
            let annotation = MKPointAnnotation()
            annotation.title = "내 위치"
            annotation.coordinate = coord
            self.mapView.addAnnotation(annotation)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateForSelectedDistrict()
    }

    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        if filterSegmentedControl.selectedSegmentIndex == 3 {
            updateFavoritePlaces()
            favoritesTableView.reloadData()
            favoritesTableView.isHidden = false
            mapView.isHidden = true
        } else {
            favoritesTableView.isHidden = true
            mapView.isHidden = false
            updateAnnotations()
        }
    }

    func updateFavoritePlaces() {
        favoritePlaces = filteredPlaces.filter { UserDefaults.standard.bool(forKey: "favorite_\($0.name)") }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaces.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let place = favoritePlaces[indexPath.row]
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = place.description
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = favoritePlaces[indexPath.row]
        let coord = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        filterSegmentedControl.selectedSegmentIndex = 0
        favoritesTableView.isHidden = true
        mapView.isHidden = false
        updateAnnotations()
    }

    func updateAnnotations() {
        let filter = filterSegmentedControl.selectedSegmentIndex
        mapView.removeAnnotations(mapView.annotations)
        for place in filteredPlaces {
            let visited = UserDefaults.standard.bool(forKey: "visited_\(place.name)")
            let favorite = UserDefaults.standard.bool(forKey: "favorite_\(place.name)")
            if filter == 1 && !visited { continue }
            if filter == 2 && visited { continue }
            if filter == 3 && !favorite { continue }
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            mapView.addAnnotation(annotation)
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        if let place = filteredPlaces.first(where: { $0.name == annotation.title }) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier:   "PlaceDetailViewController") as? PlaceDetailViewController {
                detailVC.placeName = place.name
                detailVC.placeType = place.type
                detailVC.placeImageName = place.image
                detailVC.placeDescription = place.description
                detailVC.placeLatitude = place.latitude
                detailVC.placeLongitude = place.longitude
                detailVC.placeAddress = place.address
                detailVC.placeOpenTime = place.openTime
                detailVC.placeSiteURL = place.siteURL
                detailVC.isVisited = UserDefaults.standard.bool(forKey: "visited_\(place.name)")
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }

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
        if let place = filteredPlaces.first(where: { $0.name == annotation.title }) {
            annotationView?.pinTintColor = (place.type == "관광지") ? .systemBlue : .systemRed
        } else {
            annotationView?.pinTintColor = .systemGray
        }
        return annotationView
    }

    func centerMapOnDistrict(_ district: String) {
        // Example coordinates for districts (you can replace with actual coordinates)
        let districtCoordinates: [String: CLLocationCoordinate2D] = [
            "관악구": CLLocationCoordinate2D(latitude: 37.4802, longitude: 126.9527),
            // Add more districts as needed
        ]
        if let coordinate = districtCoordinates[district] {
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        }
    }

    func centerMapOnPlace(_ placeName: String) {
        if let place = allPlaces.first(where: { $0.name == placeName }) {
            let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            // Simulate a tap on the annotation to show the detail view
            if let annotation = mapView.annotations.first(where: { ($0 as? MKPointAnnotation)?.title == placeName }) {
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
}
