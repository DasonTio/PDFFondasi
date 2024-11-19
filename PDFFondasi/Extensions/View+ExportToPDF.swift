//
//  View+ExportToPDF.swift
//  PDFFondasi
//
//  Created by Dason Tiovino on 19/11/24.
//

import SwiftUI
import UIKit

extension View {
    func asPDF(completion: @escaping (Data?) -> Void) {
        // Create a UIHostingController to host the SwiftUI view
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let size = controller.view.intrinsicContentSize
        
        // Ensure the view has the correct size
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
        
        // Force layout
        view?.setNeedsLayout()
        view?.layoutIfNeeded()
        
        // Render the view as an image
        DispatchQueue.main.async {
            let imageRenderer = UIGraphicsImageRenderer(size: size)
            let image = imageRenderer.image { _ in
                view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
            }
            
            // Create a PDF context and draw the image into it
            let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: size))
            
            // Use the pdfData(actions:) method to generate the PDF data
            let pdfData = pdfRenderer.pdfData { context in
                context.beginPage()
                image.draw(in: CGRect(origin: .zero, size: size))
            }
            
            completion(pdfData)
        }
    }
    
    static func exportToPDF<Content: View>(view: Content, completion: @escaping (Data?) -> Void) {
        // Create a UIHostingController with the provided view
        let controller = UIHostingController(rootView: view)
        let view = controller.view
        let size = controller.view.intrinsicContentSize
        
        // Ensure the view has the correct size
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
        
        // Force layout
        view?.setNeedsLayout()
        view?.layoutIfNeeded()
        
        // Render the view as an image
        DispatchQueue.main.async {
            let imageRenderer = UIGraphicsImageRenderer(size: size)
            let image = imageRenderer.image { _ in
                view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
            }
            
            // Create a PDF context and draw the image into it
            let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: size))
            
            // Use the pdfData(actions:) method to generate the PDF data
            let pdfData = pdfRenderer.pdfData { context in
                context.beginPage()
                image.draw(in: CGRect(origin: .zero, size: size))
            }
            
            completion(pdfData)
        }
    }
    
}
