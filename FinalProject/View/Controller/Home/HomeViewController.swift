import UIKit
import MapKit
import CoreLocation
import SVProgressHUD

final class HomeViewController: ViewController {

	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var currentLocationButton: CustomButton!

	// MARK: - Properties
	private var detailView: DetailView!
	private var viewModel = HomeViewModel()
	private var currentLocation: CLLocationCoordinate2D?
	private var mapCenterLocation: CLLocationCoordinate2D?
	private var firstLoadMap: Bool = true

	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		mapView.showsUserLocation = true
		configDetailView()
		LocationManager.shared.getCurrentLocation(completion: { [weak self] (location) in
			guard let `self` = self else { return }
			self.currentLocation = location.coordinate
			self.mapCenterLocation = location.coordinate
			self.center(location: location.coordinate)
		})
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		makeNavigationBarTransparent()
	}

	func makeNavigationBarTransparent(isTranslucent: Bool = true) {
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
	@objc func menuTouchUpInside() {

	}

	@objc func searchTouchUpInside() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.delegate = self
		present(searchController, animated: true, completion: nil)
	}

// MARK: - Private Methods
	private func center(location: CLLocationCoordinate2D) {
		mapView.setCenter(location, animated: true)
		let span = MKCoordinateSpan(latitudeDelta: Config.latitudeDelta, longitudeDelta: Config.longitudeDelta)
		let region = MKCoordinateRegion(center: location, span: span)
		mapView.setRegion(region, animated: true)
	}

	private func configDetailView() {
		if detailView == nil {
			guard let userView = Bundle.main.loadNibNamed(Config.detailView, owner: self, options: nil)?.first as? DetailView else { return }
			userView.frame = CGRect(x: Config.originX, y: Config.originY, width: view.bounds.width, height: Config.hightView)
			detailView = userView
			view.addSubview(detailView)
		}
	}

// MARK: - Action
	@IBAction func moveCurrentLocation(_ sender: Any) {
		guard let currentLocation = self.currentLocation else { return }
		center(location: currentLocation)
	}
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {

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
		if firstLoadMap {
			firstLoadMap = false
		} else {
			guard let placeLocation = mapCenterLocation else { return }
			let location: CLLocation = CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude)
			let mapViewCenterLocation: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
			let distanceInMeters = location.distance(from: mapViewCenterLocation)
			print("--> ", distanceInMeters)
			if distanceInMeters >= Constant.distance && distanceInMeters <= Constant.maxDistance {
				self.mapCenterLocation = mapViewCenterLocation.coordinate
				getVenueForHome(currentLocation: placeLocation)
				print("OK  😄")
			}
		}
	}
}

// MARK: Load Api
extension HomeViewController {
	func getVenueForHome(currentLocation: CLLocationCoordinate2D) {
		SVProgressHUD.show()
		viewModel.getVenues(currentLocation: currentLocation) { [weak self] (result) in
			guard let this = self else {
				return
			}
			switch result {
			case .success:
				//	this.mapView.removeAnnotations(this.mapView.annotations)
				SVProgressHUD.dismiss()
				this.viewModel.getDetail(at: 0) { (result) in
					switch result {
					case .failure(let error):
						print(error.localizedDescription)
					case .success:
						print("total: Ok")
						DispatchQueue.main.async {
							this.detailView.viewModel = DetailViewModel(ObjectManager.share.venues, ObjectManager.share.venueDetails)
						}
					}
				}
				ObjectManager.share.venues.forEach { (venue) in
					if let location = venue.location {
						let annotation = MKPointAnnotation()
						annotation.coordinate = location
						annotation.title = venue.name
						this.mapView.addAnnotation(annotation)
					}
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
				let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtide)
				self.getVenueForHome(currentLocation: coordinate)
				let span = MKCoordinateSpan(latitudeDelta: Config.latitudeDelta, longitudeDelta: Config.longitudeDelta)
				let region = MKCoordinateRegion(center: coordinate, span: span)
				self.mapView.setRegion(region, animated: true)
			}
		}
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
		static let latitudeDelta: CLLocationDegrees = 0.005
		static let longitudeDelta: CLLocationDegrees = 0.005

	}
}
