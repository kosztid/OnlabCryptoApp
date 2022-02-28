//
//  ChartView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import SwiftUI

struct ChartView: View {
    var values: [CGFloat]
    var body: some View {
        VStack{
            LineGraph(values: values.normalized)
                .stroke()
                .stroke(lineWidth: 2)
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
        }
        
    }
}
struct LineGraph: Shape{
    var values: [CGFloat]
    let screenwidth = UIScreen.main.bounds.width
    
    func path(in rect: CGRect) -> Path{
        
        func point(at ix: Int) -> CGPoint{
            let point = values[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(values.count-1)
            let y = (1 - point) * rect.height
            
            return CGPoint(x: x, y: y)
        }
        return Path{ p in
            guard values.count > 1 else {return}
            let start = values[0]
            p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
            
            for idx in values.indices{
                p.addLine(to: point(at: idx))
            }
        }
    }
}

extension Array where Element == CGFloat {
    var normalized: [CGFloat]{
        if let min = self.min(), let max = self.max(){
            return self.map {
                ($0-min) / (max-min)
            }
        }
        return []
    }
}
/*
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView([)
    }
}
 */
