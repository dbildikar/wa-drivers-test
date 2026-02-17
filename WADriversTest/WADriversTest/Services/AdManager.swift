import SwiftUI
import GoogleMobileAds

/// Manages AdMob banner ads
class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()
    
    // Production Ad Unit ID
    static let bannerAdUnitID = "ca-app-pub-1940989276629699/8704648497"
    
    @Published var shouldRefreshAd = false
    
    private override init() {
        super.init()
    }
    
    /// Trigger ad refresh
    func refreshAd() {
        shouldRefreshAd.toggle()
    }
}

/// SwiftUI wrapper for GADBannerView
struct AdBannerView: UIViewRepresentable {
    let adUnitID: String
    @Binding var refreshTrigger: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.delegate = context.coordinator
        
        // Get the root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootVC
        }
        
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func updateUIView(_ bannerView: GADBannerView, context: Context) {
        // Refresh ad when trigger changes
        if context.coordinator.lastRefreshState != refreshTrigger {
            context.coordinator.lastRefreshState = refreshTrigger
            bannerView.load(GADRequest())
        }
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        var lastRefreshState = false
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            // Ad loaded successfully
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            // Ad failed to load - will show blank space
            print("Ad failed to load: \(error.localizedDescription)")
        }
    }
}

/// Container view that shows the ad banner at the bottom
struct AdBannerContainer: View {
    @ObservedObject var adManager = AdManager.shared
    
    var body: some View {
        AdBannerView(
            adUnitID: AdManager.bannerAdUnitID,
            refreshTrigger: $adManager.shouldRefreshAd
        )
        .frame(height: 50)
        .background(Color.black.opacity(0.1))
    }
}
