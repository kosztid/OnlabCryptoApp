import SwiftUI

struct ChartView: View {
    var values: [CGFloat]
    var body: some View {
        VStack {
            Divider()
            LineGraph(values: values.normalized)
                .stroke()
                .stroke(lineWidth: 2)
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
            Divider()
        }
    }
}
struct LineGraph: Shape {
    var values: [CGFloat]
    let screenwidth = UIScreen.main.bounds.width

    func path(in rect: CGRect) -> Path {
        func point(at idx: Int) -> CGPoint {
            let point = values[idx]
            let xcoord = rect.width * CGFloat(idx) / CGFloat(values.count - 1)
            let ycoord = (1 - point) * rect.height

            return CGPoint(x: xcoord, y: ycoord)
        }
        return Path { path in
            guard values.count > 1 else {return}
            let start = values[0]
            path.move(to: CGPoint(x: 0, y: (1 - start) * rect.height))

            for idx in values.indices {
                path.addLine(to: point(at: idx))
            }
        }
    }
}

extension Array where Element == CGFloat {
    var normalized: [CGFloat] {
        if let min = self.min(), let max = self.max() {
            return self.map {
                ($0 - min) / (max - min)
            }
        }
        return []
    }
}
