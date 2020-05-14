import Foundation

class ObjectManager {

	static let share: ObjectManager = {
		return ObjectManager()
	}()

	var venueHomes: [VenueHome] = []
	var venueDetails: [VenueDetail] = []
}
