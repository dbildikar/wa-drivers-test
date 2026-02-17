import SwiftUI

struct SplashView: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            // Background image (same as launch screen)
            Image("LaunchImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            // Progress bar at the bottom
            VStack {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Loading questions...")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .frame(width: 200)
                        .scaleEffect(y: 2)
                }
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    SplashView(progress: .constant(0.5))
}
