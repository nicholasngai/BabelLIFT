import Foundation

import KissXML

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

class LIFTParser {
    private let doc: XMLDocument

    init(data: Data) throws {
        doc = try XMLDocument(data: data, options: 0)
    }

    func getParsed() throws -> LIFT {
        let root = doc.rootElement()
        if root == nil {
            throw LIFTParserError.invalidInput
        }
        var liftEntries: [LIFTEntry] = []
        for entryNode in root!.children! {
            guard let entry = entryNode as? XMLElement else { continue }
            if entry.name != "entry" {
                continue
            }
            var lexicalUnits: [String: String] = [:]
            var senses: [String: String] = [:]
            for lexicalUnitOrSenseNode in entry.children! {
                guard let lexicalUnitOrSense = lexicalUnitOrSenseNode as? XMLElement else { continue }
                switch lexicalUnitOrSense.name {
                case "lexical-unit":
                    for formNode in lexicalUnitOrSense.children! {
                        guard let form = formNode as? XMLElement else { continue }
                        let lang = form.attributesAsDictionary()["lang"]
                        if form.name != "form" || lang == nil {
                            continue
                        }
                        for textNode in form.children! {
                            guard let text = textNode as? XMLElement else { continue }
                            if text.name != "text" || text.stringValue == nil || text.stringValue == "" {
                                continue
                            }
                            lexicalUnits[lang!] = text.stringValue!
                        }
                    }
                case "sense":
                    for glossNode in lexicalUnitOrSense.children! {
                        guard let gloss = glossNode as? XMLElement else { continue }
                        let lang = gloss.attributesAsDictionary()["lang"]
                        if gloss.name != "gloss" || lang == nil {
                            continue
                        }
                        for textNode in gloss.children! {
                            guard let text = textNode as? XMLElement else { continue }
                            if text.name != "text" || text.stringValue == nil || text.stringValue == "" {
                                continue
                            }
                            senses[lang!] = text.stringValue!
                        }
                    }
                default:
                    break
                }
                if lexicalUnits.count == 0 || senses.count == 0 {
                    continue
                }
                liftEntries.append(LIFTEntry(lexicalUnits: lexicalUnits, senses: senses))
            }
        }
        return LIFT(entries: liftEntries)
    }
}
