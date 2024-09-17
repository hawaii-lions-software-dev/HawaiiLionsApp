import SwiftUI

struct TodayView: View {
    var animation: Namespace.ID
    @EnvironmentObject public var selectedObject: SelectedObject
    @State private var scrollOffset: CGFloat = 0
    @StateObject var fetchHomeDataService = HomePageClient()


    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(Date().formatted(date: .complete, time: .omitted).uppercased())
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.gray)
                            Text("Aloha").font(.system(size: 40, weight: .bold, design: .default))
                        }
                        Spacer()
                    }
                    .padding([.leading, .top, .trailing])

                    switch fetchHomeDataService.loadingStatus {
                        case .loading:
                            ForEach(0..<25) { item in
                                ContactLoadCell()
                            }
                        case .success:
                            LazyVGrid(columns: [GridItem()], content: {
                                ForEach(fetchHomeDataService.items!, id: \.self) { item in
                                    CardView(animation: animation, itemName: item.title, itemSubtitle: item.subtitle, itemDescription: item.description)
                                    .padding([.bottom], 15)
                                    .id(item.title)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                                            selectedObject.title = item.title
                                            selectedObject.subtitle = item.subtitle
                                            selectedObject.description = item.description
                                            selectedObject.textContent = item.textContent
                                            selectedObject.isShowing = true
                                        }
                                    }
                                }
                            })
                        case .error:
                            Text("Error, please try again later. If this issue persists, please contact informationtechnology@hawaiilions.org")
                    }
                    
                    
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                           value: $0.frame(in: .named("scrollView")).minY)
                })
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.scrollOffset = value
            }
            .onAppear {
                proxy.scrollTo(selectedObject.title, anchor: .center)
            }
            .refreshable {
                await fetchHomeDataService.fetchData(url: "https://hawaiilions.org/testing.json")
            }
        }
        .environmentObject(fetchHomeDataService)
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedObject = SelectedObject()
        selectedObject.title = "PBJ Sand"
        selectedObject.isShowing = true

        return TodayView(animation: Namespace().wrappedValue)
            .environmentObject(selectedObject)
    }
}
