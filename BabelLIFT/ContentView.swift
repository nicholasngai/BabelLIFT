import SwiftUI

struct ContentView: View {
    @State private var lexicons: [String: LIFT] = [:]

    var body: some View {
        let lexiconNames = lexicons.keys.sorted()

        NavigationView {
            List {
                ForEach(lexiconNames, id: \.self) { name in
                    let lexicon = lexicons[name]!
                    NavigationLink(destination: LexiconView(name: name, lexicon: lexicon)) {
                        Text(name)
                    }
                }
                NavigationLink("Import New Lexicon...", destination: ImportLIFTView(onImport: addLexicon))
            }
            .navigationTitle("BabelLIFT")
        }
    }

    private func addLexicon(_ name: String, _ lift: LIFT) -> String? {
        if lexicons[name] != nil {
            return "Lexicon with name already exists"
        }
        lexicons[name] = lift
        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
