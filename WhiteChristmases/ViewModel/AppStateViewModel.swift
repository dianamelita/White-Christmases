import Foundation

class AppStateViewModel: ObservableObject {
    @Published var didFinishLoading = false

    func loadInitialDataIfNeeded() {
        FIPSCountryLoader().loadAllFIPSCodesFromFile()
        USStateLoader().seedUSStatesIfNeeded()

        // Add delay to simulate loading or animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.didFinishLoading = true
        }
    }
}
