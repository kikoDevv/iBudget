import Foundation

extension String {
    var localized: String {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        let isSwedish = preferredLanguage.hasPrefix("sv")
        let isEnglish = preferredLanguage.hasPrefix("en")

        // If the language is not Swedish or English, force English
        let language = isSwedish ? "sv" : "en"

        let path = Bundle.main.path(forResource: language, ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}