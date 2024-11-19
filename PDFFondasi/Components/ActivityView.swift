//
//  ActivityView.swift
//  PDFFondasi
//
//  Created by Dason Tiovino on 19/11/24.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        // For iPad support (if needed)
        controller.popoverPresentationController?.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
