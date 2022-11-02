import SwiftUI

extension View {
    // swiftlint:disable:next function_parameter_count
    func alertWithTf(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String) -> Void, secondaryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
        }
        alert.addAction(.init(title: secondaryTitle, style: .cancel) { _ in
            secondaryAction()
        })
        alert.addAction(.init(title: primaryTitle, style: .default) { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        })
        rootController().present(alert, animated: true, completion: nil)
    }

    // swiftlint:disable:next function_parameter_count
    func alertWithTfNumpad(title: String, message: String, hintText: String, primaryTitle: String, secTitle: String, primaryAction: @escaping (String) -> Void, secondaryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
            field.keyboardType = .numberPad
        }
        alert.addAction(.init(title: secTitle, style: .cancel) { _ in
            secondaryAction()
        })
        alert.addAction(.init(title: primaryTitle, style: .default) { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        })
        rootController().present(alert, animated: true, completion: nil)
    }
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
