import UIKit

class CityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var cityDescriptionLabel: UILabel!

    let cities = ["서울", "부산", "대구"]
    let descriptions = [
        "서울 – 대한민국의 수도로, 역사와 현대가 조화를 이룬 도시입니다.",
        "부산 – 아름다운 해변과 활기찬 항구도시.",
        "대구 – 전통과 패션이 공존하는 도시."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        cityDescriptionLabel.text = descriptions[0]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityDescriptionLabel.text = descriptions[row]
        UserDefaults.standard.set(row, forKey: "SelectedCityIndex")
    }
} 
