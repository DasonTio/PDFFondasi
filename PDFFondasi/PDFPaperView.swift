//
//  PDFPaperView.swift
//  Impulsum
//
//  Created by Dason Tiovino on 19/11/24.
//

import SwiftUI

struct MaterialSD: Identifiable{
    var id: UUID = UUID();
    public let image: String;
    public let brand: String;
    public let name: String;
    public let tag: String;
    
    init(image: String, brand: String, name: String, tag: String = "") {
        self.image = image
        self.brand = brand
        self.name = name
        self.tag = tag
    }
}

//MARK: A4 Paper Size
struct PDFPaperView: View {
    @State private var showPDF = false
    @State private var pdfData: Data?
    private var spacing:CGFloat = 20;
    
    @State private var data = [
        MaterialSD(
            image: "AFRICA-BEIGE",
            brand: "Habitat",
            name: "Africa Beige"
        ),
        MaterialSD(
            image: "AFRICA-LIGHT-BEIGE",
            brand: "Habitat",
            name: "Africa Light Beige"
        ),
        MaterialSD(
            image: "APOLLO",
            brand: "Apex",
            name: "Apollo"
        ),
    ]
    
    var body: some View {
        VStack (alignment: .leading){
            HStack(alignment: .top){
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 66)
                Spacer()
                Image("CallToAction")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 81)
            }
            
            Text("Living Room")
                .padding(.vertical)
            
            Divider().pdfDivider()
                .padding(
                    .bottom, spacing
                )
            
            HStack(spacing: 50){
                VStack(alignment: .leading){
                    Text("Screenshot")
                    GeometryReader{ geometry in
                        Image("Screenshot")
                            .resizable()
                            .mask{
                                RoundedRectangle(cornerRadius: 10)
                            }
                        
                        
                        
                    }
                }
                
                VStack(alignment: .center){
                    Text("Floor Plan")
                    Divider()
                    FloorPlanCanvasView()
                        .frame(
                            width: 221,
                            height: 250
                        )
                        
                }.frame(
                    alignment: Alignment(
                        horizontal: .leading,
                        vertical: .center
                    )
                )
            }
            .frame(
                height: 400
            )
            
            VStack{
                Text("Details")
                Divider()
            }
            .padding(.top, spacing)
            
            HStack(spacing: 10){
                ForEach(data, id: \.image){ val in
                    materialRowView(material: val)
                }
            }
            
//            Table(data){
//                TableColumn("Tag", value:\.tag)
//                TableColumn("Brand", value: \.brand)
//                TableColumn("Type", value: \<#Root#>.type)
//                TableColumn("Color", value: \.color)
//                TableColumn("Area(m2)", value: \.area)
//                TableColumn("Waste(m2)", value: \.waste)
//                TableColumn("Usage", value: \.usage)
//                TableColumn("Unit", value: \.unit)
//                TableColumn("Note", value: \.note)
//            }
            
            

        }
        .foregroundStyle(.text)
        .frame(
            width: 595,
            height: 842,
            alignment: Alignment(
                horizontal: .leading,
                vertical: .top
            )
        )
        .padding(66)
        .sheet(isPresented: $showPDF) {
            if let data = pdfData {
                ActivityView(activityItems: [data])
            } else {
                Text("Failed to load PDF.")
            }
        }
    }
    
    func materialRowView(material: MaterialSD) -> some View {
        VStack(spacing: 0) {
            VStack {
                Image(material.image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .cornerRadius(8, corners: [.topLeft, .topRight])
            }.padding(.bottom, 8)
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(material.brand)
                        .font(.system(size: 4.3))
                        .fontWeight(.regular)
                    
                    Text(material.name)
                        .font(.system(size: 6))
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                }
                .padding(.leading, 8)
                
                
                Spacer()
                
            }
        }
        .frame(
            width: 58,
            height: 87
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.neutral100)
        )
    }
}


#Preview {
    PDFPaperView()
}
