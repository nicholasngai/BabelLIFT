import Foundation

struct LIFTEntry {
    let lexicalUnits: [String: String]
    let senses: [String: String]
}

struct LIFT {
    let entries: [LIFTEntry]
}

enum LIFTParserError: Error {
    case invalidInput
}

class LIFTParser: XMLParser {
    private var parsed: LIFT? = nil

    private var path: [String] = []
    private var curLang: String? = nil
    private var curLexicalUnits: [String: String]? = nil
    private var curSenses: [String: String]? = nil
    private var curEntries: [LIFTEntry] = []

    override init(data: Data) {
        super.init(data: data)
        self.delegate = self
    }

    func getParsed() throws -> LIFT {
        if parsed == nil {
            throw LIFTParserError.invalidInput
        }
        return parsed!
    }
}

extension LIFTParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        path.append(elementName)

        switch path {
        case ["lift", "entry"]:
            curLexicalUnits = [:]
            curSenses = [:]
        case ["lift", "entry", "lexical-unit", "form"], ["lift", "entry", "sense", "gloss"]:
            curLang = attributeDict["lang"]
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch path {
        case ["lift"]:
            parsed = LIFT(entries: curEntries)
        case ["lift", "entry"]:
            let entry = LIFTEntry(lexicalUnits: curLexicalUnits!, senses: curSenses!)
            curEntries.append(entry)
        case ["lift", "entry", "lexical-unit", "form"], ["lift", "entry", "sense", "gloss"]:
            curLang = nil
        default:
            break
        }

        path.removeLast()
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch path {
        case ["lift", "entry", "lexical-unit", "form", "text"]:
            curLexicalUnits![curLang!] = string
        case ["lift", "entry", "sense", "gloss", "text"]:
            curSenses![curLang!] = string
        default:
            break
        }
    }
}
