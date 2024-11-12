import SwiftUI


struct OnboardingScreen: View {
    let title: String
    let description: String
    let imageName: String
    
    @State private var selectedCurrency: Currency = AppConfig.mainCurrency {
        didSet {
            AnalyticsManager.shared.logEvent(eventType: .currencyChanged)
            AppConfig.updateMainCurrency(to: selectedCurrency)
            print("Selected currency changed to: \(selectedCurrency.rawValue)") // Debugging print
        }
    }
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: UIScreen.main.bounds.height * 0.05)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .scaleEffect(scale) // Увеличение масштаба
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        scale = 1.1 // Плавное увеличение изображения при появлении
                    }
                }
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary) // Использование стандартного цвета для текста
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .animation(.easeIn(duration: 0.3), value: title)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary) // Более мягкий цвет для описания
                .multilineTextAlignment(.center)
                .padding([.horizontal, .bottom])
                .lineLimit(nil) // Поддержка многострочного текста
                .animation(.easeIn(duration: 0.3), value: description)
            
            if title == "Set your currency" {
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(Currency.allCases, id: \.self) { currency in
                        Text(currency.description)
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: selectedCurrency) { _,newValue in
                    print("Picker selection changed to: \(newValue.description)") // Debugging print
                    selectedCurrency = newValue
                }
            }
            
            Spacer()
        }
    }
}


// MARK: - OnboardingView
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isOnboardingCompleted: Bool
    @State private var showButton = false
    @State private var showDiscountButton = false
    
    var body: some View {
        TabView(selection: $viewModel.currentIndex) {
            ForEach(0..<viewModel.screens.count, id: \.self) { index in
                viewModel.screens[index]
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(
            
            VStack {
                if ![viewModel.paywallIndex, viewModel.discountIndex].contains(viewModel.currentIndex) {
                    Spacer()
                    HStack {
                        Spacer()
                        if viewModel.currentIndex < viewModel.screens.count - 1 {
                            Button {
                                viewModel.next()
                            } label: {
                                Text("Next")
                                    .font(.title2)
                                    .padding()
                            }
                            
                        } else {
                            Button {
                                UserOnboarder.setWelcomeOnboarded()
                                self.isOnboardingCompleted = true
                            } label: {
                                Text("Start")
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                           
                            Spacer()
                        }
                    }
                    .padding()
                    Spacer()
                        .frame(height: 20)

                } else {
                    
                    HStack {
                        Spacer() // для выравнивания кнопки по правому краю
                        if (showButton && viewModel.currentIndex == viewModel.paywallIndex) ||
                            (showDiscountButton && viewModel.currentIndex == viewModel.discountIndex)  {
                            Button(action: {
                                print("clicked")
                                viewModel.next()
                            }) {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .foregroundColor(.gray)
                                    .contentShape(Rectangle()) // Увеличиваем область клика (можно использовать для всего компонента)
                            }
                            .transition(.opacity) // Добавляем анимацию появления
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topTrailing) // выравнивание по правому верхнему углу
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentIndex)
                    .onAppear {
                        if showButton {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showDiscountButton = true
                                }
                            }
                        }
                        
                        // Задержка в 3 секунды перед появлением кнопки
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showButton = true
                            }
                        }
                        
                    }
                    Spacer()
                }
            }
        )
    }
}


