//
//  ScanAnimationView.swift
//  Snap Check Money Under Control
//
//  Created by PowerMac on 12.02.2025.
//

import SwiftUI

struct ScanAnimationView: View {
    @State private var scanOffset: CGFloat = -50  // Начальная позиция линии
    var uiImage: UIImage

    var body: some View {
        ZStack {
            // Фон с изображением чека
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.green.opacity(0.6)) // Чуть ярче
                            .frame(width: geometry.size.width, height: 6) // Ширина = ширине картинки
                            .cornerRadius(3) // Закруглённые края
                            .shadow(color: .green.opacity(0.8), radius: 5, x: 0, y: 2) // Тень для объёма
                            .offset(y: scanOffset)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                    scanOffset = geometry.size.height
                                }
                            }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Скруглённые углы для изображения
                .shadow(radius: 5) // Общая тень для эффекта "карточки"
                
        }
        .padding()
    }
}



#Preview {
    ScanAnimationView(uiImage: .photoCheck)
}
