//
//  ViewController.swift
//  CityGuideApp
//
//  Created by 장원진 on 6/5/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    // MARK: - UI Outlets
    @IBOutlet weak var locationPinImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var whereToGoLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestLabel: UILabel!
    @IBOutlet weak var suggestCardView: UIView!
    @IBOutlet weak var suggestImageView: UIImageView!
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var placesTableView: UITableView!

    // MARK: - Data
    var allPlaces: [Place] = []
    var filteredPlaces: [Place] = []
    var suggestedPlace: Place?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPlaces()
        filterPlaces()
    }

    func setupUI() {
        // 핀 이미지
        locationPinImageView.image = UIImage(systemName: "mappin.and.ellipse")
        locationLabel.text = "GwanakGu, Seoul"
        whereToGoLabel.text = "어디로 가고 싶으세요?"
        searchBar.placeholder = "ex)관악구"
        suggestLabel.text = "Suggest"
        suggestCardView.layer.cornerRadius = 16
        suggestCardView.layer.shadowColor = UIColor.black.cgColor
        suggestCardView.layer.shadowOpacity = 0.1
        suggestCardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        suggestCardView.layer.shadowRadius = 4
        letsGoButton.layer.cornerRadius = 12
        categoryLabel.text = "Category"
        categorySegmentedControl.removeAllSegments()
        categorySegmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
        categorySegmentedControl.insertSegment(withTitle: "Attraction", at: 1, animated: false)
        categorySegmentedControl.insertSegment(withTitle: "Restaurant", at: 2, animated: false)
        categorySegmentedControl.selectedSegmentIndex = 0
        placesTableView.delegate = self
        placesTableView.dataSource = self
        searchBar.delegate = self
    }

    func loadPlaces() {
        // placeData.json에서 데이터 불러오기
        guard let url = Bundle.main.url(forResource: "placeData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            print("placeData.json 로드 실패")
            return
        }
        allPlaces = jsonArray.compactMap { dict in
            guard let name = dict["name"] as? String,
                  let type = dict["type"] as? String,
                  let lat = dict["latitude"] as? Double,
                  let lon = dict["longitude"] as? Double,
                  let desc = dict["description"] as? String,
                  let image = dict["image"] as? String,
                  let address = dict["address"] as? String else { return nil }
            // Add description for '낙성대공원'
            if name == "낙성대공원" {
                return Place(name: name, type: type, latitude: lat, longitude: lon, description: desc + " 낙엽이 아름답게 떨어지는 곳입니다.", image: image, address: address)
            }
            return Place(name: name, type: type, latitude: lat, longitude: lon, description: desc, image: image, address: address)
        }
        suggestedPlace = allPlaces.randomElement()
    }

    func filterPlaces() {
        // 카테고리 필터
        let selectedIndex = categorySegmentedControl.selectedSegmentIndex
        let selectedCategory: String? = {
            switch selectedIndex {
            case 1: return "관광지" // Tourist Attraction
            case 2: return "맛집"   // Restaurant
            default: return nil     // All
            }
        }()
        // 검색어 필터
        let searchText = searchBar.text?.lowercased() ?? ""
        filteredPlaces = allPlaces.filter { place in
            let matchesCategory = selectedCategory == nil || place.type == selectedCategory
            let matchesSearch = searchText.isEmpty || place.address.lowercased().contains(searchText) || place.name.lowercased().contains(searchText)
            return matchesCategory && matchesSearch
        }
        placesTableView.reloadData()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaces.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = filteredPlaces[indexPath.row]
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = place.type
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 지도 이동 기능 구현
    }

    // MARK: - SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPlaces()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        // Navigate to the map tab and center on the searched district
        if let tabBarController = self.tabBarController, let mapVC = tabBarController.viewControllers?[1] as? MapViewController {
            tabBarController.selectedIndex = 1
            mapVC.centerMapOnDistrict(searchText)
        }
    }

    // MARK: - Actions
    @IBAction func letsGoButtonTapped(_ sender: UIButton) {
        // Navigate to '낙성대공원' on the map
        if let tabBarController = self.tabBarController, let mapVC = tabBarController.viewControllers?[1] as? MapViewController {
            tabBarController.selectedIndex = 1
            mapVC.centerMapOnPlace("낙성대공원")
        }
    }
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        filterPlaces()
    }
}

// Place 모델 예시 (실제 프로젝트의 Place 모델을 import해서 사용하세요)
struct Place {
    let name: String
    let type: String
    let latitude: Double
    let longitude: Double
    let description: String
    let image: String
    let address: String
}

