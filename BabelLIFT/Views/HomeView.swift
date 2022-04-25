import SwiftUI

struct HomeView: View {
    @State private var isShowingFileImporter = false

    var body: some View {
        NavigationView {
            List {
                Button(action: { isShowingFileImporter.toggle(); print(isShowingFileImporter) }) {
                    Text("Load new lexicon...")
                }
            }
            .navigationTitle("BabelLIFT")
        }
        // TODO Restrict to .lift.
        .fileImporter(isPresented: $isShowingFileImporter, allowedContentTypes: [.item], onCompletion:handleLoadLift)

    }

    private func handleLoadLift(result: Result<URL, Error>) {
        do {
            let url = try result.get()
            let data = try Data(contentsOf: url)
            let liftParser = LIFTParser(data: data)
            liftParser.parse()
            print(liftParser.getParsed())
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
