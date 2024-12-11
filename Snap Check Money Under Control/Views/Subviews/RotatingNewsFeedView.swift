import SwiftUI

struct RotatingNewsFeedView: View {
    @State private var currentIndex = 0
    @State private var scrollOffset: CGFloat = 0
    let newsItems: [(String, String?)]
    let timer = Timer.publish(every: 12.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                if let link = newsItems[currentIndex].1, let url = URL(string: link) {
                    Link(destination: url) {
                        scrollableText(newsItems[currentIndex].0, width: geometry.size.width)
                            .foregroundColor(.gray)
                    }
                } else {
                    scrollableText(newsItems[currentIndex].0, width: geometry.size.width)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.all, 0)
        .onReceive(timer) { _ in
            scrollOffset = 0 // Сбросить прокрутку
            withAnimation {
                currentIndex = (currentIndex + 1) % newsItems.count
            }
        }
    }
    
    @ViewBuilder
    private func scrollableText(_ text: String, width: CGFloat) -> some View {
        let textWidth = textWidth(for: text, font: UIFont.preferredFont(forTextStyle: .headline))
        let shouldScroll = textWidth > width
        
        if shouldScroll {
            ScrollView(.horizontal, showsIndicators: false) {
                Text(text)
                    .font(.headline)
                    .lineLimit(1)
                    .offset(x: -scrollOffset)
                    .onAppear {
                        let scrollDuration = 10.0 // Длительность прокрутки
                        let totalDistance = textWidth - width
                        
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                            withAnimation(.linear(duration: scrollDuration)) {
                                scrollOffset = totalDistance
                            }
                        }
                    }
            }
        } else {
            // Center the text when it fits within the width
            Text(text)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center) // Ensures centering
        }
    }
    
    private func textWidth(for text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = text.size(withAttributes: attributes)
        return size.width
    }
}
