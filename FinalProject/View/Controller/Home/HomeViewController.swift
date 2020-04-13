import UIKit
import MapKit
import CoreLocation
import SVProgressHUD

final class HomeViewController: ViewController {

	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var currentLocationButton: CustomButton!

	// MARK: - Properties
	private var blackScreen: UIView!
	private var sliderBarView: SliderBarView!
	private var detailView: DetailView!
	private var viewModel = HomeViewModel()
	private var currentLocation: CLLocationCoordinate2D?
	private var mapCenterLocation: CLLocationCoordinate2D?

	private var dispatchGroup = DispatchGroup()

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configMapView()
		configDetailView()
		setupMenu()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		makeNavigationBarTransparent()
	}

	// MARK: - ConfigMap
	private func configMapView() {
		mapView.delegate = self
		mapView.showsUserLocation = true
		LocationManager.shared.getCurrentLocation(completion: { [weak self] (location) in
			guard let `self` = self else { return }
			self.currentLocation = location.coordinate
			self.mapCenterLocation = location.coordinate
			self.center(location: location.coordinate)
		})
	}
	// MARK: - NavigationBar
	private func makeNavigationBarTransparent(isTranslucent: Bool = true) {
		let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-search-50"), style: .plain, target: self, action: #selector(searchTouchUpInside))
		let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-menu-51"), style: .plain, target: self, action: #selector(menuTouchUpInside))
		searchButton.tintColor = #colorLiteral(red: 0.8098723292, green: 0.02284341678, blue: 0.3325383663, alpha: 1)
		menuButton.tintColor = #colorLiteral(red: 0.8098723292, green: 0.02284341678, blue: 0.3325383663, alpha: 1)
		navigationItem.rightBarButtonItem = searchButton
		navigationItem.leftBarButtonItem = menuButton
		if let navBar = self.navigationController?.navigationBar {
			let blankImage = UIImage()
			navBar.setBackgroundImage(blankImage, for: .default)
			navBar.shadowImage = blankImage
			navBar.isTranslucent = isTranslucent
		}
	}
	// MARK: - Setup Menu Method
	private func setupMenu() {
		sliderBarView = SliderBarView(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height))
		sliderBarView.delegate = self
		sliderBarView.layer.zPosition = 100
		navigationController?.view.addSubview(sliderBarView)
		blackScreen = UIView(frame: view.bounds)
		blackScreen.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2757651969)
		blackScreen.isHidden = true
		blackScreen.layer.zPosition = 99
		view.addSubview(blackScreen)
		let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
		blackScreen.addGestureRecognizer(tapGestRecognizer)
	}

// MARK: - Action Menu
	@objc private func menuTouchUpInside() {
		blackScreen.isHidden = false
		navigationController?.isNavigationBarHidden = true
		UIView.animate(withDuration: 0.5, animations: {
			self.sliderBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.height)
			self.blackScreen.frame = CGRect(x: self.sliderBarView.frame.width, y: 0, width: self.view.frame.width - self.sliderBarView.frame.width, height: self.view.bounds.height + 100)
		})
	}
// MARK: - Action Back Screen
	@objc private func blackScreenTapAction(sender: UITapGestureRecognizer) {
		blackScreen.isHidden = true
		blackScreen.frame = view.bounds
		UIView.animate(withDuration: 0.5) {
			self.sliderBarView.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height)
		}
		navigationController?.isNavigationBarHidden = false
	}

// MARK: - Action Search
	@objc private func searchTouchUpInside() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.delegate = self
		present(searchController, animated: true, completion: nil)
	}

// MARK: - Method map center
	private func center(location: CLLocationCoordinate2D) {
		mapView.setCenter(location, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: Config.latitudeDelta, longitudeDelta: Config.longitudeDelta)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
	}

	// MARK: - Methods zoom level
	private func zoomLevel(location: CLLocationCoordinate2D) {
		guard let mapCenterLocation = mapCenterLocation else { return }
		let mapCoordinates = MKCoordinateRegion(center: mapCenterLocation, latitudinalMeters: Config.zoomDistance, longitudinalMeters: Config.zoomDistance)
		mapView.setRegion(mapCoordinates, animated: true)
	}

	// MARK: - Methods Config View
	private func configDetailView() {
		if detailView == nil {
			guard let userView = Bundle.main.loadNibNamed(Config.detailView, owner: self, options: nil)?.first as? DetailView else { return }
			userView.frame = CGRect(x: Config.originX, y: Config.originY, width: view.bounds.width, height: Config.hightView)
			detailView = userView
			view.addSubview(detailView)
		}
	}

// MARK: - Action Current Location
	@IBAction private func moveCurrentLocationTouchUpInside(_ sender: Any) {
		guard let currentLocation = currentLocation else { return }
		center(location: currentLocation)
	}
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKPointAnnotation {
			let identifier = Config.identifier
			var view: MKPinAnnotationView

			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				let button = UIButton(type: .infoLight)
				button.setImage(#imageLiteral(resourceName: "icons8-more-than-52"), for: .normal)
				button.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
				button.addTarget(self, action: #selector(selectPinView(_:)), for: .touchDown)
				view.rightCalloutAccessoryView = button
				view.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "pin"))
				view.canShowCallout = true
			}
			return view
		}
		return nil
	}

	@objc private func selectPinView(_ sender: UIButton?) {
		let detailVC = DetailViewController()
		detailVC.viewModel = viewModel.detailViewControllerModel()
		navigationController?.pushViewController(detailVC, animated: true)
	}

	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		guard let currentLocation = currentLocation else { return }
		getVenueForHome(currentLocation: currentLocation)
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		let selectedAnnotation = view.annotation as? MKPointAnnotation
		guard let coordinate = selectedAnnotation?.coordinate else { return }
		center(location: coordinate)
		if let venue = viewModel.getVenue(at: coordinate) {
			viewModel.selectedVenue = venue
			detailView.scrollCollectionView(to: venue)
		}
	}

	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		guard let placeLocation = mapCenterLocation else { return }
		let location: CLLocation = CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude)
		let mapViewCenterLocation: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
		let distanceInMeters = location.distance(from: mapViewCenterLocation)
		print(" 🚗 --> ", distanceInMeters)
		if distanceInMeters >= Constant.distance && distanceInMeters <= Constant.maxDistance {
			mapCenterLocation = mapViewCenterLocation.coordinate
			getVenueForHome(currentLocation: mapViewCenterLocation.coordinate, query: "")
		}
	}
}

// MARK: Load Api
extension HomeViewController {
	func getVenueForHome(currentLocation: CLLocationCoordinate2D, query: String = "") {
		SVProgressHUD.show()
		ObjectManager.share.venueHomes.removeAll()
		ObjectManager.share.venueDetails.removeAll()
		viewModel.getVenues(currentLocation: currentLocation, query: query) { [weak self] (result) in
			guard let this = self else { return }
			switch result {
			case .success:
				this.mapView.removeAnnotations(this.mapView.annotations)
				ObjectManager.share.venueHomes.forEach { (venue) in
					this.dispatchGroup.enter()
					SVProgressHUD.dismiss()
					guard let id = venue.id else { return }
					this.viewModel.getDetail(id: id) { (result) in
						switch result {
						case .failure(let error):
							print(error.localizedDescription)
						case .success:
							print("Success 🤡")
						}
						this.dispatchGroup.leave()
					}
					DispatchQueue.main.async {
						if let location = venue.location {
							let annotation = MKPointAnnotation()
							annotation.coordinate = location
							annotation.title = venue.name
							annotation.subtitle = venue.country

							this.mapView.addAnnotation(annotation)
						}
					}
				}
				this.dispatchGroup.notify(queue: .main) {
					this.detailView.viewModel = DetailViewModel(ObjectManager.share.venueHomes, ObjectManager.share.venueDetails)
				}
			case .failure(let error):
				this.alert(msg: error.localizedDescription, handler: nil)
			}
		}
	}
}

// MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		UIApplication.shared.beginReceivingRemoteControlEvents()
		let activityIndicator = UIActivityIndicatorView()
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.startAnimating()
		self.view.addSubview(activityIndicator)
		searchBar.resignFirstResponder()
		dismiss(animated: true, completion: nil)
		let searchRequest = MKLocalSearch.Request()
		searchRequest.naturalLanguageQuery = searchBar.text
		let activeSearch = MKLocalSearch(request: searchRequest)
		activeSearch.start { (response, error) in
			activityIndicator.stopAnimating()
			UIApplication.shared.endReceivingRemoteControlEvents()
			if response == nil {
				print(error?.localizedDescription as Any)
			} else {
				self.mapView.removeAnnotations(self.mapView.annotations)
				guard let latitude = response?.boundingRegion.center.latitude,
					let longtide = response?.boundingRegion.center.longitude else { return }
				let annotation = MKPointAnnotation()
				annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtide)
				self.mapView.addAnnotation(annotation)
				let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtide)
				self.getVenueForHome(currentLocation: coordinate, query: "")
				self.center(location: coordinate)
			}
		}
	}
}
// MARK: SliderBarViewDelegate
extension HomeViewController: SliderBarViewDelegate {
	func sidebarDidSelectRow(typeOfLocation: String) {
		guard let currentLocation = currentLocation else { return }
		getVenueForHome(currentLocation: currentLocation, query: typeOfLocation)
		zoomLevel(location: currentLocation)
	}
}

// MARK: Config
extension HomeViewController {
	struct Config {
		static let detailView: String = "DetailView"
		static let identifier: String = "Pin"
		static let originX: CGFloat = 0
		static let originY: CGFloat = 610
		static let hightView: CGFloat = 200
		static let latitudeDelta: CLLocationDegrees = 0.01
		static let longitudeDelta: CLLocationDegrees = 0.01
		static let zoomDistance: CLLocationDistance = 5_000
	}
}
