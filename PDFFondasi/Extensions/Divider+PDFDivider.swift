//
//  Divider+PDFDivider.swift
//  PDFFondasi
//
//  Created by Dason Tiovino on 19/11/24.
//

import SwiftUI

extension Divider{
    func pdfDivider()->some View{
        Rectangle()
            .fill(Color.brand)
            .frame(
                width: 43.64,
                height: 1.64
            )
    }
}
