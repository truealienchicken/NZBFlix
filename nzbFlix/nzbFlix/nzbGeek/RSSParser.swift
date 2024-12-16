import UIKit

class RSSParser: NSObject, XMLParserDelegate {
    private var movies: [Movie] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentImageURL = ""

    func parse(data: Data) -> [Movie] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return movies
    }

    // MARK: - XMLParserDelegate Methods

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        currentElement = elementName
        if elementName == "item" {
            currentTitle = ""
            currentImageURL = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "coverurl":
            currentImageURL += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let cleanedTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines).removingParenthesesContent()
            
            // Extract year from the title, assuming it's in parentheses at the end
            let year = currentTitle.extractYearFromTitle()
            
            let movie = Movie(
                title: cleanedTitle,
                description: "",
                imageURL: currentImageURL.trimmingCharacters(in: .whitespacesAndNewlines),
                year: year
            )
            movies.append(movie)
        }
    }
    
}

extension String {
    func removingParenthesesContent() -> String {
        return self.replacingOccurrences(of: "\\s*\\([^)]*\\)", with: "", options: .regularExpression)
    }

    func extractYearFromTitle() -> String {
        let pattern = "\\((\\d{4})\\)" // Matches a year in parentheses
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(self.startIndex..<self.endIndex, in: self)
        if let match = regex?.firstMatch(in: self, options: [], range: range),
           let yearRange = Range(match.range(at: 1), in: self) {
            return String(self[yearRange])
        }
        return "" // Return empty string if no year is found
    }
}
