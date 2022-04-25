import SwiftUI

struct ImportLIFTView: View {
    let onImport: (_ name: String, _ lift: LIFT) -> String?

    @State private var name = ""
    @State private var lift: LIFT? = nil
    @State private var liftFilename: String? = nil
    @State private var isShowingFileImporter = false
    @State private var shownError = ""
    @State private var isShowingError = false

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name")
                    TextField("Lexicon name", text: $name)
                }
                HStack {
                    Button(action: { isShowingFileImporter.toggle(); print(isShowingFileImporter) }) {
                        Text("Select file...")
                    }
                    if liftFilename != nil {
                        Text(liftFilename!)
                    }
                }
            }
            .navigationTitle("Import New")
        }
        .toolbar {
            Button(role: .destructive, action: handleDone) {
                Text("Done")
                    .bold()
            }
            .disabled(name == "" || lift == nil)
        }
        // TODO Restrict to .lift.
        .fileImporter(isPresented: $isShowingFileImporter, allowedContentTypes: [.item], onCompletion:handleLoadLift)
        .alert(shownError, isPresented: $isShowingError) {}
    }

    private func handleLoadLift(result: Result<URL, Error>) {
        do {
            let url = try result.get()
            assert(url.startAccessingSecurityScopedResource())
            let data = try Data(contentsOf: url)
            let liftParser = LIFTParser(data: data)
            liftParser.parse()
            lift = liftParser.getParsed()
            liftFilename = url.lastPathComponent
        } catch {
            print(error)
        }
    }

    private func handleDone() {
        let error = onImport(name, lift!)
        if error != nil {
            shownError = error!
            isShowingError = true
            return
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct ImportLIFTView_Previews: PreviewProvider {
    static var previews: some View {
        ImportLIFTView(onImport: { name, lift in nil })
    }
}
