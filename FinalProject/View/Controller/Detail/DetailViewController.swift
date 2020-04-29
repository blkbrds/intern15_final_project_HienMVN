import UIKit
import MapKit
import SDWebImage
import SVProgressHUD

final class DetailViewController: ViewController {

	// MARK: Outlet
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var cityLabel: UILabel!

	@IBOutlet weak private var favoriteButton: UIButton!
	@IBOutlet weak private var timeOpenLabel: UILabel!
	@IBOutlet weak private var locationImageView: UIImageView!
	@IBOutlet weak private var discriptionLabel: UILabel!
	@IBOutlet weak private var likeLabel: UILabel!
	@IBOutlet weak private var ratingLabel: UILabel!
	@IBOutlet weak private var locationNameLabel: UILabel!
	@IBOutlet weak private var addressLabel: UILabel!

	// MARK: Properties
	var viewModel: DetailViewControllerModel? {
		didSet {
			if viewModel?.venueDetail == nil {
				viewModel?.getVenuesDetail(completion: { [weak self] (result) in
					guard let this = self else { return }
					switch result {
					case .failure(let error):
						self?.alert(msg: error.localizedDescription, handler: nil)
					case .success:
						DispatchQueue.main.async {
							this.getAPIForDetail()
							guard let location = this.viewModel?.getLocationCoordinate() else { return }
							this.center(location: location)
							this.setupUI()
						}

					}
				})
			}
			getAPIForDetail()
		}
	}

	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 0.2901675105, green: 0.29021433, blue: 0.2901572585, alpha: 1)
		mapView.delegate = self
		guard let location = viewModel?.getLocationCoordinate() else { return }
		center(location: location)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let realm = RealmManager.shared.realm else { return }
		guard let locationName = locationNameLabel.text else { return }
		if realm.objects(VenueDetail.self).filter(NSPredicate(format: "name = %@", locationName)).isEmpty {
			favoriteButton.isSelected = false
		} else {
			favoriteButton.isSelected = true
		}
		makeNavigationBarTransparent()
	}

	private func makeNavigationBarTransparent(isTranslucent: Bool = true) {
		if let navBar = self.navigationController?.navigationBar {
			let blankImage = UIImage()
			navBar.setBackgroundImage(blankImage, for: .default)
			navBar.shadowImage = blankImage
			navBar.isTranslucent = isTranslucent
		}
	}

	// MARK: Private Methods
	override func setupUI() {
		guard let item = viewModel?.venueDetail else { return }
		locationNameLabel.text = item.name
		addressLabel.text = item.address
		cityLabel.text = item.city
		ratingLabel.text = String(item.rating)
		likeLabel.text = String(item.countOfLike)
		discriptionLabel.text = item.descriptionText
		if let prefix = item.prefix, let sufix = item.suffix {
			let url = prefix + "414x414" + sufix
			locationImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "dsad"))
		}
		timeOpenLabel.text = item.openTime
		favoriteButton.isSelected = item.favorite
	}

	private func center(location: CLLocationCoordinate2D) {
		mapView.setCenter(location, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: Config.latitudeDelta, longitudeDelta: Config.longitudeDelta)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
	}

	// MARK: Action
	@IBAction func favoriteButtonTouchUpInside(_ sender: Any) {
		favoriteButton.isSelected = !favoriteButton.isSelected
		viewModel?.didUpdateFavorite()
	}
}

// MARK: Get API
extension DetailViewController {
	func getAPIForDetail() {
		SVProgressHUD.show()
		guard let locationCoordinate = viewModel?.getLocationCoordinate() else { return }
		viewModel?.getVenues(currentLocation: locationCoordinate) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success:
				this.viewModel?.venues.forEach({ (venue) in
					if let location = venue.location {
						let annotation = MKPointAnnotation()
						annotation.coordinate = location
						annotation.title = venue.name
						this.mapView.addAnnotation(annotation)
					}
				})
			case .failure(let error):
				this.alert(msg: error.localizedDescription, handler: nil)
			}
		}
		SVProgressHUD.dismiss()
	}
}

// MARK: MKMapViewDelegate
extension DetailViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKPointAnnotation {
			let identifier = Config.identifier
			var view: PinView

			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PinView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				view = PinView(annotation: annotation, reuseIdentifier: identifier)
				let button = UIButton(type: .detailDisclosure)
				button.addTarget(self, action: #selector(selectPinView(_:)), for: .touchDown)
				view.rightCalloutAccessoryView = button
				view.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "pin"))
				view.canShowCallout = true
			}
			return view
		}
		return nil
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		let selectedAnnotation = view.annotation as? MKPointAnnotation
		guard let coordinate = selectedAnnotation?.coordinate else { return }
		guard let viewModel = viewModel else { return }
		if let venue = viewModel.getVenue(at: coordinate) {
			viewModel.selectedVenue = venue
		}
	}

	@objc private func selectPinView(_ sender: UIButton?) {
		let detailVC = DetailViewController()
		detailVC.viewModel = viewModel?.detailViewControllerModel()
		navigationController?.pushViewController(detailVC, animated: true)
	}
}

// MARK: Config
extension DetailViewController {
	struct Config {
		static let detailView: String = "DetailView"
		static let identifier: String = "Pin"
		static let originX: CGFloat = 0
		static let originY: CGFloat = 610
		static let hightView: CGFloat = 200
		static let latitudeDelta: CLLocationDegrees = 0.005
		static let longitudeDelta: CLLocationDegrees = 0.005
		static let lineWidth: CGFloat = 6
	}
}
