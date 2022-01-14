//
//  CTARCLView.swift
//  CrustyTour
//
//  Created by Madelaine Boyd on 1/14/22.
//

import Foundation
import SwiftUI
import UIKit
import ARKit


// Maybe use this to host in SwiftUI in the future
// Overkill for now
class CTARCLView : UIView {
    var body: some View {
      return CTARCLViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct CTARCLViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> CTARCLView {
        let arView = CTARCLView()
        return arView
        
    }
    
    func updateUIView(_ uiView: CTARCLView, context: Context) {}
    
    
}
