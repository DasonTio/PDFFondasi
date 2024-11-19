//
//  ContentView.swift
//  PDFFondasi
//
//  Created by Dason Tiovino on 19/11/24.
//

import SwiftUI

struct ContentView: View{
    @State private var showShareSheet = false
    @State private var pdfData: Data?
    @State private var isExporting: Bool = false

    var body: some View{
        VStack{
            if (isExporting){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }else{
                Button(action: {
                    exportPDF()
                }){
                    Text("Export PDF")
                }
            }

        }.sheet(isPresented: $showShareSheet){
            if let data = pdfData {
                ActivityView(activityItems: [data])
            } else {
                Text("No PDF data available.")
            }
        }
    }
    
    func exportPDF() {
        let exportableView = PDFPaperView()

        PDFManager.exportToPDF(view: exportableView) { data in
            self.isExporting = true
            DispatchQueue.main.async {
                if let data = data {
                    self.isExporting = false
                    self.pdfData = data
                    self.showShareSheet = true
                } else {
                    print("Failed to create PDF data.")
                }
            }
        }
    }
}
