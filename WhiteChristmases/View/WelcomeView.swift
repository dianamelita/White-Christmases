import SwiftUI
import MapKit

struct WelcomeView: View {
    @ObservedObject var viewModel: AppStateViewModel

    var body: some View {
        ZStack(alignment: .center) {
            // Full-screen background
            Image("snow-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            // Centered content
            VStack(spacing: 20) {
                Image("globe")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .shadow(radius: 5)

                VStack(spacing: 5) {
                    Text("White Christmas")
                        .font(.system(size: 40, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    Text("Explorer")
                        .font(.system(size: 40, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.loadInitialDataIfNeeded()
        }
    }
}
