import UIKit
import MapKit
import SDWebImage
import SVProgressHUD

final class DetailViewController: ViewController {

	// MARK: Outlet
	@IBOutlet weak private var ratingView: RatingView!
	@IBOutlet weak private var mapView: MKMapView!
	@IBOutlet weak private var cityLabel: UILabel!
	@IBOutlet weak private var favoriteButton: UIButton!
	@IBOutlet weak private var timeOpenLabel: UILabel!
	@IBOutlet weak private var locationImageView: UIImageView!
	@IBOutlet weak private var discriptionLabel: UILabel!
	@IBOutlet weak private var likeLabel: UILabel!
	@IBOutlet weak private var locationNameLabel: UILabel!
	@IBOutlet weak private var addressLabel: UILabel!
	@IBOutlet weak private var tableView: UITableView!

	// MARK: Properties
	private var currentLocation: CLLocationCoordinate2D?
	private var favoriting: Bool = true
	var viewModel: DetailViewControllerModel? {
		didSet {
			if viewModel?.venueDetail == nil {
				SVProgressHUD.show()
				viewModel?.getVenuesDetail(completion: { [weak self] (result) in
					guard let this = self else { return }
					switch result {
					case .failure(let error):
						self?.alert(msg: error.localizedDescription, handler: nil)
					case .success:
						this.getAPIVenuesSimilar()
						DispatchQueue.main.async {
							this.setupUI()
							SVProgressHUD.dismiss()
						}
					}
				})
			}
			getAPIVenuesSimilar()
		}
	}

	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configMapView()
		configTableView()
		getAPIVenuesSimilar()
		navigationController?.isNavigationBarHidden = true
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
	}

	// MARK: Private Methods
	private func configMapView() {
		mapView.delegate = self
		mapView.showsUserLocation = true
		LocationManager.shared.locationDetailDelegate = self
		LocationManager.shared.startUpdating { _ in }
		guard let lat = viewModel?.venueDetail?.lat,
			let long = viewModel?.venueDetail?.lng else { return }
		let venueCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
		// test routing
		routing(source: mapView.userLocation.coordinate, destination: venueCoordinate)
		addPin(coordinate: venueCoordinate)
		center(location: venueCoordinate)
	}

	private func configTableView() {
		let nib = UINib(nibName: Config.detailTableViewCell, bundle: .main)
		tableView.register(nib, forCellReuseIdentifier: Config.detailTableViewCell)
		tableView.dataSource = self
		tableView.delegate = self
	}

	// MARK: Action Back To Home_VC
	@IBAction private func backTouchUpInside(_ sender: Any) {
		navigationController?.popViewController(animated: true)
		navigationController?.isNavigationBarHidden = false
	}

// MARK: Action Favorite
	@IBAction private func favoriteTouchUpInside(_ sender: Any) {
		if favoriting {
			favoriteButton.isSelected = !favoriteButton.isSelected
			viewModel?.didUpdateFavorite()
			favoriting = false
		} else {
			favoriteButton.isSelected = !favoriteButton.isSelected
			viewModel?.deleteFavorite()
			favoriting = true
		}
	}

// MARK: Private Methods
	override func setupUI() {
		guard let item = viewModel?.venueDetail else { return }
		locationNameLabel.text = item.name
		addressLabel.text = item.address
		cityLabel.text = item.city
		ratingView.rating = item.rating / 2
		likeLabel.text = String(item.countOfLike)
		discriptionLabel.text = item.descriptionText
		if let prefix = item.prefix, let sufix = item.suffix {
			let url = prefix + Config.sizeOfImage + sufix
			locationImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "dsad"))
			let imageBackgrond = UIImageView()
			imageBackgrond.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "dsad"))
			imageBackgrond.alpha = 0.7
			tableView.backgroundView = imageBackgrond
		}
		timeOpenLabel.text = item.openTime
		favoriteButton.isSelected = item.favorite
		let venueCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lng)
		addPin(coordinate: venueCoordinate)
		routing(source: mapView.userLocation.coordinate, destination: venueCoordinate)
	}

	private func center(location: CLLocationCoordinate2D) {
		mapView.setCenter(location, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: Config.latitudeDelta, longitudeDelta: Config.longitudeDelta)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
	}

	private func addPin(coordinate: CLLocationCoordinate2D) {
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		mapView.addAnnotation(annotation)
	}

	private func routing(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
		request.requestsAlternateRoutes = true
		request.transportType = .automobile

		let directions = MKDirections(request: request)

		directions.calculate { [unowned self] (response, _) in
			guard let unwrappedResponse = response else { return }

			for route in unwrappedResponse.routes {
				self.mapView.addOverlay(route.polyline)
				self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
			}
		}
	}
}

// MARK: Get API
extension DetailViewController {
	func getAPIVenuesSimilar() {
		guard let locationCoordinate = viewModel?.getLocationCoordinate() else { return }
		viewModel?.getVenues(currentLocation: locationCoordinate) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success:
				this.tableView.reloadData()
				print("Get API success")
			case .failure(let error):
				this.alert(msg: error.localizedDescription, handler: nil)
			}
		}
	}
}

// MARK: MKMapViewDelegate
extension DetailViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKPointAnnotation {
			let identifier = Config.identifier
			var view: MKPinAnnotationView

			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			}
			return view
		}
		return nil
	}

	// MARK: - Renderer
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

		if let polyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: polyline)
			renderer.strokeColor = #colorLiteral(red: 0, green: 0.7669754028, blue: 0.3210973144, alpha: 1)
			renderer.lineWidth = 6
			return renderer
		}
		return MKOverlayRenderer()
	}
}

// MARK: TableViewDataSource
extension DetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let numberofRows = viewModel?.venues.count else { return 0 }
		return numberofRows
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.detailTableViewCell, for: indexPath) as? DetailTableViewCell else {
			return DetailTableViewCell()
		}
		cell.viewModel = viewModel?.getDetailTableViewModel(at: indexPath)
		return cell
	}
}

// MARK: TableViewDelegate
extension DetailViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailVC = DetailViewController()
		viewModel?.selectedVenue = viewModel?.venues[indexPath.row]
		detailVC.viewModel = viewModel?.detailViewControllerModel()
		navigationController?.pushViewController(detailVC, animated: true)
	}
}

extension DetailViewController: LocationManagerDelegate {
	func locationManager(locationManager: LocationManager, didUpdateCurrentLocation currentLocation: CLLocation) {
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
		static let latitudeDelta: CLLocationDegrees = 0.01
		static let longitudeDelta: CLLocationDegrees = 0.01
		static let lineWidth: CGFloat = 6
		static let sizeOfImage: String = "414x854"
		static let detailTableViewCell: String = "DetailTableViewCell"
		static let heightForRow: CGFloat = 130
	}
}
