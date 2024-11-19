//
//  FloorPlanCanvasView.swift
//  Impulsum
//
//  Created by Dason Tiovino on 18/11/24.
//
import SwiftUI
import simd

struct FloorPlanCanvasView: View {
    @State var positions: [SIMD3<Float>] = [
        SIMD3(x: 0, y: 0, z: 0),
        SIMD3(x: 1, y: 0, z: 0),
        SIMD3(x: 1, y: 0, z: 1),
        SIMD3(x: 0, y: 0, z: 1),
        SIMD3(x: 0, y: 0, z: 0),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let scaleFactor: Float = 80.0

            // Calculate min and max values to center the floorplan
            let minX = positions.map { $0.x }.min() ?? 0
            let maxX = positions.map { $0.x }.max() ?? 0
            let minZ = positions.map { $0.z }.min() ?? 0
            let maxZ = positions.map { $0.z }.max() ?? 0

            let offsetX = (minX + maxX) / 2
            let offsetZ = (minZ + maxZ) / 2
            
            let points: [CGPoint] = positions.map { pos in
                let x = CGFloat((pos.x - offsetX) * scaleFactor + Float(width) / 2)
                let y = CGFloat((pos.z - offsetZ) * scaleFactor + Float(height) / 2)
                return CGPoint(x: x, y: y)
            }
//            let data = screenshotManager.data
            Canvas { context, size in
                for i in 0..<(positions.count - 1) {
                    let pos = positions[i]
                    let nextPos = positions[i + 1]

                    let startX = CGFloat((pos.x - offsetX) * scaleFactor + Float(width) / 2)
                    let startY = CGFloat((pos.z - offsetZ) * scaleFactor + Float(height) / 2)
                    let endX = CGFloat((nextPos.x - offsetX) * scaleFactor + Float(width) / 2)
                    let endY = CGFloat((nextPos.z - offsetZ) * scaleFactor + Float(height) / 2)

                    // Draw the line
                    var path = Path()
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                    context.stroke(path, with: .color(.black), lineWidth: 2)

                    let deltaX = nextPos.x - pos.x
                    let deltaZ = nextPos.z - pos.z
                    let distance = sqrt(deltaX * deltaX + deltaZ * deltaZ)

                    let midX = (startX + endX) / 2
                    let midY = (startY + endY) / 2

                    let dirX = endX - startX
                    let dirY = endY - startY
                    let length = sqrt(dirX * dirX + dirY * dirY)
                    let normDirX = dirX / length
                    let normDirY = dirY / length
                    
                    let perpX = -normDirY
                    let perpY = normDirX
                    let offsetMagnitude: CGFloat = -40
                    let textX = midX + perpX * offsetMagnitude
                    let textY = midY + perpY * offsetMagnitude

                    let distanceString = String(format: "%.2f m\n", distance)
                    let text = Text(distanceString)
                        .font(.system(size: 16))
                        .foregroundColor(.black)

                    context.draw(text, at: CGPoint(x: textX, y: textY))
                }
                
                var path = Path()
                if let firstPoint = points.first {
                    path.move(to: firstPoint)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    path.addLine(to: firstPoint)
                }
                
                context.stroke(path, with: .color(.black), lineWidth: 2)
                
                let area = calculatePolygonArea(points: points, scaleFactor: scaleFactor)
                
                let centroid = calculateCentroid(points: points, area: area, scaleFactor: scaleFactor)
                
                let areaString = String(format: "%.2f m²\n(FL-1)", area)
                let text = Text(areaString)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                context.draw(text, at: centroid)
            }
            .background(Color.white)
        }
        .onAppear{
//            if let entityPoints = screenshotManager.data.first?.entity.points{
//                self.positions = entityPoints
//                self.positions.append(entityPoints[0])
//            }
        }
    }
    
    func calculatePolygonArea(points: [CGPoint], scaleFactor: Float) -> Double {
        guard points.count > 2 else { return 0.0 }
        
        var area: Double = 0.0
        let n = points.count
        for i in 0..<n {
            let j = (i + 1) % n
            let xi = Double(points[i].x)
            let yi = Double(points[i].y)
            let xj = Double(points[j].x)
            let yj = Double(points[j].y)
            area += (xi * yj) - (xj * yi)
        }
        return abs(area) / 2.0 / (Double(scaleFactor) * Double(scaleFactor))
    }
    
    func calculateCentroid(points: [CGPoint], area: Double, scaleFactor: Float) -> CGPoint {
        guard points.count > 2 else { return CGPoint.zero }
        
        var centroidX: Double = 0.0
        var centroidY: Double = 0.0
        let n = points.count
        var factor: Double
        for i in 0..<n {
            let j = (i + 1) % n
            let xi = Double(points[i].x)
            let yi = Double(points[i].y)
            let xj = Double(points[j].x)
            let yj = Double(points[j].y)
            factor = (xi * yj) - (xj * yi)
            centroidX += (xi + xj) * factor
            centroidY += (yi + yj) * factor
        }
        let areaMultiplier = 1.0 / (6.0 * area * Double(scaleFactor) * Double(scaleFactor))
        centroidX *= areaMultiplier
        centroidY *= areaMultiplier
        return CGPoint(x: centroidX, y: centroidY)
    }
}
