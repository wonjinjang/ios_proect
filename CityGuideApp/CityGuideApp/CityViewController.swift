import UIKit

class CityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var cityDescriptionLabel: UILabel!

    let districts = ["관악구", "강남구", "동작구", "금천구", "영등포구", "용산구", "성북구"]
    let descriptions = [
        "관악구 – 서울 남서부에 위치한 자연과 대학이 어우러진 구.",
        "강남구 – 서울의 대표적인 번화가와 비즈니스 중심지.",
        "동작구 – 한강과 산책로, 주거지역이 조화로운 구.",
        "금천구 – IT산업과 주거가 공존하는 남서부 지역.",
        "영등포구 – 금융과 쇼핑, 여의도가 있는 구.",
        "용산구 – 이태원, 한강, 남산 등 다양한 명소가 있는 구.",
        "성북구 – 대학가와 전통이 어우러진 북부 지역."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        cityDescriptionLabel.text = descriptions[0]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return districts.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return districts[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityDescriptionLabel.text = descriptions[row]
        UserDefaults.standard.set(row, forKey: "SelectedDistrictIndex")
    }
} 
