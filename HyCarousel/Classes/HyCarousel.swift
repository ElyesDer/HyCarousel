//
//  HyCarousel.swift
//  HyCarousel
//
//  Created by ElyesDer on 20/2/2021.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct HyCarousel<Data, ID, Content>: View where Data: RandomAccessCollection, ID: Hashable, Content: View , Data.Index : Hashable {
    
    @EnvironmentObject var configurator : Configurator
    
    private struct IndexWrapper : Identifiable { var id: Int }
    
    /// The collection of underlying identified data that HyCarousel uses to initiate dynamically.
    private let data: [Data.Element]
    /// A function that creates content using the underlying data.
    
    //    we will use indices to loop through RandomAccessCollection, so no ID:Identifiable required
    private let content: (Data.Element) -> Content
    
    private let identityKeyPath: KeyPath<Data.Element, ID>
    
    /// - Parameters:
    ///   - data: The data that the `ForEach` instance uses to create views dynamically.
    ///   - content: The view builder that creates views dynamically.
    public init(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder _ content: @escaping (Data.Element) -> Content) {
        self.data = data.map { $0 }
        identityKeyPath = id
        self.content = content
    }
    
    public var body : some View {
        GeometryReader { fullView in
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { reader in
                    LazyHStack(spacing : configurator.spacing) {
                        self.content(using: fullView)
                    }
                    .padding(.horizontal, (fullView.size.width - (((configurator.viewSize.width) / 2))) / 2)
                    .background(configurator.backgroundColor)
                    .onReceive(configurator.$selectedIndex, perform: { newIndex in
                        withAnimation(.default, {
                            reader.scrollTo(newIndex, anchor : .center)
                        })
                    })
                }
            }
            .coordinateSpace(name: "scroll")
        }
        .background(Color.red)
    }
    
    @ViewBuilder
    private func content(using fullView: GeometryProxy) -> some View {
        
        ForEach((0..<self.data.count).map { IndexWrapper(id: $0) }) { wrapper in
            GeometryReader { geo in
                let computedAngle = computeAngle(Double(geo.frame(in: .named("Custom")).midX - fullView.size.width / 2) / 4, index : wrapper.id)
                self.content(self.data[wrapper.id])
                    .modifier(AngleModifier(angle: .degrees(computedAngle)))
                    .scaleEffect(x : configurator.scaleRatio.x, y : configurator.scaleRatio.y)
                    .if(configurator.selectedIndex == wrapper.id, if: {
                        $0
                    }, else: {
                        $0.highPriorityGesture(TapGesture().onEnded({
                            DispatchQueue.main.async {
                                self.configurator.selectedIndex = wrapper.id
                            }
                        }))
                    })
            }
            .frame(width: configurator.viewSize.width, height: configurator.viewSize.height, alignment: .center)
        }
    }
    
    fileprivate func computeAngle(_ value: Double, index : Int) -> Double {
        if value > configurator.rotatedAngle.degrees {
            return configurator.rotatedAngle.degrees
        }else if value < -configurator.rotatedAngle.degrees{
            return -configurator.rotatedAngle.degrees
        }
        if -6 ... 6 ~= value {
            //            self.configurator.selectedIndex = index
        }
        
        return value
    }
}

public class Configurator: ObservableObject {
    @Published var selectedIndex = 0
    var backgroundColor : Color = .black
    var viewSize : CGSize = CGSize(width: 150, height: 200)
    var rotatedAngle : Angle = .degrees(50)
    var spacing : CGFloat = 10
    @Published var scaleRatio : CGPoint = .init(x: 1, y: 1)
    
    init(bgColor : Color = .black, viewSize : CGSize = CGSize(width: 150, height: 200) , rotatedAngle : Angle = .degrees(50), spacing : CGFloat = 10, scaleRatio : CGPoint = .init(x: 1, y: 1)) {
        self.backgroundColor = bgColor
        self.viewSize = viewSize
        self.rotatedAngle = rotatedAngle
    }
}

struct AngleModifier : ViewModifier {
    var angle : Angle = .zero
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if -angle < .degrees(1) && -angle > .degrees(-1) {
            content
        }else{
            content
                .rotation3DEffect(-angle, axis: (x: 0, y: 1, z: 0))
        }
    }
}

struct Reflection : ViewModifier {
    var color : Color = .black
    func body(content: Content) -> some View {
        VStack(spacing:0){
            content
            content
                .rotationEffect(.degrees(180))
                .scaleEffect(CGSize(width: -1.0, height: 1.0))
                .opacity(0.7)
                .overlay(
                    LinearGradient(gradient:
                                    Gradient(colors:
                                                [Color.gray.opacity(0.6), color]), // lighter gray then second color should be the same as the color background main view
                                   startPoint: .top, endPoint: .bottom)
                )
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    @ViewBuilder
    func ifLet<V, Transform: View>(
        _ value: V?,
        transform: (Self, V) -> Transform
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

struct HyCarousel_Previews: PreviewProvider {
    static var previews: some View {
        //        HyCarousel()
        EmptyView()
    }
}
