import Foundation

extension Bundle {
    private final class BundleToken {}

    static let module: Bundle = {
        let mainBundle = Bundle(for: BundleToken.self)
        guard let path = mainBundle.path(forResource: "Hired", ofType: "bundle"),
            let bundle = Bundle(path: path) else {
                return mainBundle
        }
        return bundle
     }()
}
