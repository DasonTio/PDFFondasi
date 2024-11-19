//
//  PDFManager.swift
//  PDFFondasi
//
//  Created by Dason Tiovino on 19/11/24.
//

import SwiftUI

class PDFManager {
    static func exportToPDF<Content: View>(view: Content, completion: @escaping (Data?) -> Void) {
        // Create a UIHostingController with the provided view
        let controller = UIHostingController(rootView: view)
        let view = controller.view

        // Determine the size of the view
        let targetSize = controller.view.intrinsicContentSize

        // Ensure the view has the correct size
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        // Force layout
        view?.setNeedsLayout()
        view?.layoutIfNeeded()

        // Render the view as an image
        DispatchQueue.main.async {
            let imageRenderer = UIGraphicsImageRenderer(size: targetSize)
            let image = imageRenderer.image { _ in
                view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
            }

            // Create a PDF context and draw the image into it
            let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: targetSize))

            // Generate the PDF data
            let pdfData = pdfRenderer.pdfData { context in
                context.beginPage()
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }

            completion(pdfData)
        }
    }
}
