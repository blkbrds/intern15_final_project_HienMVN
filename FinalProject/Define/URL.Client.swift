import Foundation

class URLClient {

	// 11 account
	static private var index: Int = 11

	static var idClient: [String] = [
		"?client_id=U15EYIZEPQYA1J4OD4RDOX3AODLXS2BEVPB0Q50MDV51CIQL",
		"?client_id=I5WMIF5WKLXGPJGBZM5YIGOCUULKIHXMHS2COCC3N2END4NO",
		"?client_id=UHEETIQPRKDJLTOG0U3Y0T2HA1YLWZ0O4WKTUO4ZACC3PQ4T",
		"?client_id=CO20LM5PYICHT3EJRB434WNKKVV42RTMO1JPCOG5C4VR3N1W",
		"?client_id=GEZTIHRRIMVDWLHWISXSALSBLPG0U24RTIBFBM10K0GSVMMP",
		"?client_id=E5LY2IS5QDA5G1KKIAE3XXK0OGD4T3L1U2TWT4LZFGWAMEOD",
		"?client_id=BGK43NGOZ150XD0NZGHBVJPCBBAMSJW2TRKTBAKUSCJQZ3VG",
		"?client_id=RAXXE1NLRCAU05JLOJZPF14KIJX5LVEZW22DDJ3EKCFO2VWT",
		"?client_id=Z4UIRIO1DKD4ACGHC1WEV34SQQVADQLKNBFO20YD5O3EIP3J",
		"?client_id=I0CM0JT15CT4EXX0JO5HPW30HAUN5GIBHXG1WUPAFR3R115F",
		"?client_id=RMI1XZEIGRAMT3JHGS2XZPNXY4UAYMPSNJBQASVT5VNJ0CTP",
		"?client_id=THXPRK0KM534RFYKTTHRH4XDHEXYNESVAGHTUNJ4KI3SFXUF"
	]

	static var passClient: [String] = [
		"&client_secret=Z11A3B140OMH0NZEMM2URPCCFEE1FVPB0YEPAOD5G3NB1DXE",
		"&client_secret=SO4X0QOCMMXCE54YJRLRGFFSE2LFMU3R3N5GLSQZ3SWCUGBX",
		"&client_secret=TMMAE4EHASF05XOHOR5MZDR4JDHVR2U21LS0T3HKBCYSNQQ2",
		"&client_secret=5IFDDFXM20J5FYNR3LEHGW4LVZQIRIE2S4PYBEEIGZUW0YYZ",
		"&client_secret=F2RTPDRR4DAPK2J5YSKR5XBMSDIYDY1WSMUMPPKCLLCLUMXF",
		"&client_secret=PELFEG4UP21Q1PHTCD3IZXOQPV0RII4NI5SR4MHRTKP0SXF3",
		"&client_secret=Z3ULC4WD2I3PB3O1H4D4ELBXVOQHFCEQN4FARRAIM1MAG1B4",
		"&client_secret=XM1PSUCNDWSOYVE2DZG3U0KAEOPKU2LF13HYNYVDVRX1UETV",
		"&client_secret=WMCM5FE5MEO3FFP5MEUQ5NP3O5RV1ROWDOQSADB153MHLIOE",
		"&client_secret=WLAUGOQXGCXTJ0L3ANEOVKDYKYLAHAZPRITRV04HWRSZFWPS",
		"&client_secret=PKL1ISFBTP3VJTEFF1WAONDVTT2MGC3OJVCZDYG5GLRFM5HE",
		"&client_secret=PCGPPUBMW5EMQUEFR3FW2PI1Q2QCJ04GSPSBT4DVT5NOAGOS"
	]

	static func getClientInfor() -> (idClient: String, passClient: String) {
		return (idClient: idClient[index], passClient: passClient[index])
	}
}
