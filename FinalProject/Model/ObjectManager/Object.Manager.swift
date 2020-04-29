import Foundation

class ObjectManager {

	static let share: ObjectManager = {
		return ObjectManager()
	}()

	var venues: [VenueHome] = []
	var venueDetails: [VenueDetail] = []
}
