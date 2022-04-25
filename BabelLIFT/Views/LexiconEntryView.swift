import SwiftUI

struct LexiconEntryView: View {
    let lexicalUnit: String
    let senses: [[String: String]]

    var body: some View {
        List {
            if senses.count > 1 {
                ForEach(0 ..< senses.count, id: \.self) { i in
                    Section(String(i + 1)) {
                    }
                }
            } else if senses.count == 1 {
                let sense = senses[0]
                ForEach(sense.keys.sorted(), id: \.self) { lang in
                    HStack {
                        Text(lang)
                            .opacity(0.5)
                        Text(sense[lang]!)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(lexicalUnit)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LexiconEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LexiconEntryView(lexicalUnit: "bir", senses: [["en": "child"]])
        }
    }
}
