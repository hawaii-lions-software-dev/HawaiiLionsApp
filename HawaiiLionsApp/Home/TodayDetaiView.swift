//
//  TodayDetailView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 4/3/24.
//

import SwiftUI

struct TodayDetailView: View {
    @EnvironmentObject public var selectedObject: SelectedObject
    var animation: Namespace.ID
    let itemHeight: CGFloat = 500
    let SVWidth = UIScreen.main.bounds.width - 40
    @State var scale: CGFloat = 1
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        if (selectedObject.isShowing) {
            ScrollView {
                ZStack(alignment: .center) {
                    VStack(spacing: 0) {
                        ZStack {
                            Image(selectedObject.name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: selectedObject.isShowing ? UIScreen.main.bounds.width : self.SVWidth, height: self.itemHeight)
                                .clipped()
                                .background(Color.white)
                                .font(.system(.largeTitle, design: .rounded))
                                .foregroundColor(.black)
                                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                                .edgesIgnoringSafeArea(.top)
                                .matchedGeometryEffect(id: selectedObject.name + "image", in: animation)
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Subtitle")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(.init(red: 0.8, green: 0.8, blue: 0.8)).opacity(1.0)
                                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                                        Text("\(selectedObject.name)")
                                            .font(.system(size: 36, weight: .bold, design: .default))
                                            .foregroundColor(.white)
                                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                                            .matchedGeometryEffect(id: selectedObject.name + "text", in: animation)
                                    }.padding()
                                    Spacer()
                                }.offset(y: selectedObject.isShowing ? 44 : 0)
                                Spacer()
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Description")
                                            .lineLimit(2)
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(.init(red: 0.9, green: 0.9, blue: 0.9)).opacity(0.8)
                                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                                            .matchedGeometryEffect(id: selectedObject.name + "description", in: animation)
                                    }.padding()
                                    Spacer()
                                }
                            }.padding()
                        }.frame(height: self.itemHeight).zIndex(1)
                        VStack(alignment: .leading) {
                            Text("Ingredients: ")
                                .bold()
                                .font(.title)
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean gravida ante vel est auctor pellentesque. Maecenas eleifend sodales tellus, nec cursus urna laoreet sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed scelerisque lorem luctus dui scelerisque, vel gravida purus pharetra. Cras sem tortor, laoreet eget ante a, rutrum tempor lacus. Sed turpis turpis, tincidunt a dolor vulputate, feugiat aliquam mauris. Ut et ornare dolor. Suspendisse neque nunc, volutpat at est id, sodales elementum quam. Nulla rhoncus, dolor non accumsan consequat, felis mauris lacinia dolor, quis faucibus augue risus eget est.")
                            Text("Instructions: ")
                                .bold()
                                .font(.title)
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean gravida ante vel est auctor pellentesque. Maecenas eleifend sodales tellus, nec cursus urna laoreet sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed scelerisque lorem luctus dui scelerisque, vel gravida purus pharetra. Cras sem tortor, laoreet eget ante a, rutrum tempor lacus. Sed turpis turpis, tincidunt a dolor vulputate, feugiat aliquam mauris. Ut et ornare dolor. Suspendisse neque nunc, volutpat at est id, sodales elementum quam. Nulla rhoncus, dolor non accumsan consequat, felis mauris lacinia dolor, quis faucibus augue risus eget est.")
                        }.padding().background(Color(UIColor.systemBackground)).frame(
                            maxHeight: selectedObject.isShowing ? .infinity : 0)
                    }
                    .ignoresSafeArea()
                }
                .cornerRadius(30)
                .background(GeometryReader {
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                           value: $0.frame(in: .named("scrollView")).minY)
                })
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.dragOffset = value
                if value > 5 { // Adjust this threshold value as needed
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                        selectedObject.isShowing = false
                    }                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            .ignoresSafeArea()
            .scaleEffect(self.scale)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                    self.scale = 1
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 5 { // Adjust this threshold value as needed
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                                selectedObject.isShowing = false
                            }                        }
                    }
            )
//            .refreshable {
//                withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
//                    selectedObject.isShowing = false
//                }
//            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

class ViewModel: ObservableObject {
    static var vm = ViewModel()
    @Published var y: CGFloat = 1 // Scale View Down
}

struct Screen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

//#Preview {
//    TestView()
//}
