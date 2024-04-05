//
//  TodayDetailView.swift
//  HawaiiLionsApp
//
//  Created by Kobey Arai on 4/3/24.
//

import SwiftUI

struct TodayDetaiView: View {
    @EnvironmentObject public var selectedObject: SelectedObject
    var firstLoad: Bool = true
    var animation: Namespace.ID
    let itemHeight:CGFloat = 500
    let SVWidth = UIScreen.main.bounds.width - 40
    @ObservedObject var vm = ViewModel.vm
    @State var scale: CGFloat = 1
    
    var body: some View {
        
        CustomScrollView {
            ZStack (alignment: .center){
                VStack (spacing:0){
                    ZStack{
                        Image(selectedObject.name)
                            .resizable()
                            .scaledToFill()
                            .offset(y: selectedObject.isShowing ? 0 : 0)
                            .frame(width:selectedObject.isShowing ? UIScreen.main.bounds.width : self.SVWidth, height:self.itemHeight)
                            .clipped()
                            .background(Color.white)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(.black)
                            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                            .edgesIgnoringSafeArea(.top)
                            .matchedGeometryEffect(id: selectedObject.name, in: animation) // Buggy???

                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Subtitle")
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                        .foregroundColor(.init(red: 0.8 , green: 0.8, blue: 0.8  )).opacity(1.0)
                                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                                    Text("\(selectedObject.name)")
                                        .font(.system(size: 36, weight: .bold, design: .default))
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                                }.padding()
                                Spacer()
                            }.offset(y:selectedObject.isShowing ? 44 : 0)
                            Spacer()
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Description")
                                        .lineLimit(2)
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                        .foregroundColor(.init(red: 0.9, green: 0.9, blue: 0.9)).opacity(0.8)
                                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0.0, y: 2.0)
                                }.padding()
                                Spacer()
                            }
                        }.padding()
                    }.frame(height:
                                self.itemHeight
                    ).zIndex(1)
                    VStack(alignment: .leading) {
                        Text("Ingredients: ")
                            .bold()
                            .font(.title)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean gravida ante vel est auctor pellentesque. Maecenas eleifend sodales tellus, nec cursus urna laoreet sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed scelerisque lorem luctus dui scelerisque, vel gravida purus pharetra. Cras sem tortor, laoreet eget ante a, rutrum tempor lacus. Sed turpis turpis, tincidunt a dolor vulputate, feugiat aliquam mauris. Ut et ornare dolor. Suspendisse neque nunc, volutpat at est id, sodales elementum quam. Nulla rhoncus, dolor non accumsan consequat, felis mauris lacinia dolor, quis faucibus augue risus eget est.")
                        Text("Instructions: ")
                            .bold()
                            .font(.title)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean gravida ante vel est auctor pellentesque. Maecenas eleifend sodales tellus, nec cursus urna laoreet sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed scelerisque lorem luctus dui scelerisque, vel gravida purus pharetra. Cras sem tortor, laoreet eget ante a, rutrum tempor lacus. Sed turpis turpis, tincidunt a dolor vulputate, feugiat aliquam mauris. Ut et ornare dolor. Suspendisse neque nunc, volutpat at est id, sodales elementum quam. Nulla rhoncus, dolor non accumsan consequat, felis mauris lacinia dolor, quis faucibus augue risus eget est.")
                    }.padding().background(Color.white).frame(
                        maxHeight: selectedObject.isShowing ? .infinity : 0)
                } //V
                .ignoresSafeArea()
                
            } //Z'
            .cornerRadius(30)
            
        } //SCROLLVIEW
        .frame(width: Screen.width, height: Screen.height, alignment: .center)
        .ignoresSafeArea()
        .scaleEffect(self.scale)
        .onChange(of: vm.y) { y in
            if y < 101  { //Set point at which to begin scaling down
                withAnimation(.linear(duration: 0.15)) {
                    self.scale = (1-(y/500)) //Calculates scaling using translation.y from the Gesture Recognizer
                }
            } //IF
            
            if y == 100 {withAnimation(.default) { //Limits the drag based on translation.y
                withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                    selectedObject.isShowing.toggle()
                }
            }} //IF
            
            }
        }
    }
    





struct CustomScrollView<Content:View> : UIViewRepresentable {
    @ObservedObject var viewValues = ViewModel.vm
    typealias UIViewType = UIScrollView
    let content: Content
    
    init (
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }
    
    // MARK: - MAKEUIVIEW
    
    func makeUIView(context: Context) -> UIScrollView { //Makes the initial ScrollView
        
        let scrollView = UIScrollView()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Child
        let child = UIHostingController(rootView: content)
        scrollView.addSubview(child.view)
        
        // Child Size
        let newSize = child.view.sizeThatFits(CGSize(width: Screen.width, height: .greatestFiniteMagnitude))
        child.view.frame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        scrollView.contentSize = newSize
        
        //Adds Pan gesture Recognizer
        scrollView.delegate = context.coordinator
        scrollView.panGestureRecognizer.addTarget(context.coordinator, action: #selector(Coordinator.dragged))
        
        return scrollView
        
    }
    
    //Update ScrollView
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        
    }
    
    // MARK: - COORDINATOR
    
    func makeCoordinator() -> Coordinator {
        
        Coordinator()
        
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate, ObservableObject {
        var offset: CGFloat = 0
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            self.offset = scrollView.contentOffset.y
            
            if scrollView.contentOffset.y < 1 { //Turns Bounce off at top, and sets Offset to Zero.
                scrollView.contentOffset.y = 0
                scrollView.bounces = true
                
            } else { scrollView.bounces = true } //IF
            
        } //ViewDiDScroll
        
        
        
        
        @objc func dragged(gestureRecognizer: UIPanGestureRecognizer) { // Pan Gesture Recognizer
            
            var translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            let state = gestureRecognizer.state
            
            if translation.y > 100 {translation.y = 100} //Sets a drag limit at which the view will close
            if offset == 0 { ViewModel.vm.y = translation.y } //Set a point at which the view should start closing
            if state == .ended { ViewModel.vm.y = 0 } //Reset Y value
            
            
        } //@objc
        
    } //COORDINATOR
    
} //END

class ViewModel: ObservableObject {
    
    static var vm = ViewModel()
    @Published var y : CGFloat = 1 // Scale View Down
    
}

struct Screen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

//#Preview {
//    TestView()
//}
