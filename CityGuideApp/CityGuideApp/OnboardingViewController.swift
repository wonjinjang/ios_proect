import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var cityNoteLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var bottomBoxView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.image = UIImage(named: "TripNote")
        mainImageView.image = UIImage(named: "초기화면")
        bottomBoxView.layer.cornerRadius = 24
        bottomBoxView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        startButton.layer.cornerRadius = 16
        startButton.clipsToBounds = true
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? UITabBarController {
            tabBarVC.modalPresentationStyle = .fullScreen
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
} 
