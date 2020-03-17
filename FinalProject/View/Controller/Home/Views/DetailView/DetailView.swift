import UIKit

class DetailView: UIView {

	@IBOutlet weak var detailCollectionView: UICollectionView!
	@IBOutlet weak var locationNameLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!

	var viewmodel = DetailViewModel()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		configCollectionView()
	}
	func configCollectionView() {

		detailCollectionView.dataSource = self
	}
}
extension DetailView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		<#code#>
	}
	
	
}

