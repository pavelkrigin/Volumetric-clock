//
//  ContentView.swift
//  Volumetric clock
//
//  Created by Pavel Krigin on 24.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Properies
    @State private var hoursAngle: Double = 0
    @State private var minutesAngle: Double = 0
    let timer = Timer.publish(every: 1.0, on: .main, in: .default).autoconnect()
    private let fullCircleValue: Double = 0.2
    
    //MARK: - Body
    var body: some View {
        ZStack {
            LinearGradient(colors: [.appGray, .appBlack],
                           startPoint: .topLeading,
                           endPoint: .bottom)
            bodyView
        }
        .ignoresSafeArea()
        .onReceive(timer) {
            time in withAnimation(.linear(duration: 1)) {
                minutesAngle += 360 / (fullCircleValue * 60)
                hoursAngle += 360 / (fullCircleValue * 60 * 12)
            }
        }
    }
}

//MARK: - Extension
extension ContentView {
    
    //MARK: - Body View
    var bodyView: some View {
        VStack {
            clockView
        }
        .padding(.vertical, 100)
    }
    
    //MARK: - ClockView
    private var clockView: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .fill(LinearGradient(colors: [.appGray, .appBlack], startPoint: .top, endPoint: .bottom))
                .blur(radius: 16)
                .shadow(color: .appBlack, radius: 23, x: 0, y: 25)
                .shadow(color: .appGray, radius: 23, x: 0, y: -25)
                .frame(width: 330,
                height: 330,
                       alignment: .center)
            Circle()
                .fill(LinearGradient(colors: [.appGray,.appBlack].reversed(),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .blur(radius: 3)
                .shadow(color: .appBlack,
                radius: 3,
                        x:0, y: -3)
                .shadow(color: .appBlack, radius: 3, x: 0, y: 3)
                .frame(width: 13, height: 13, alignment: .center)
            
            handsView.shadow(color: .appBlack, radius: 10, x: 7, y: 10)

        }
    }
    
    //MARK: HandsView
    private var handsView: some View{
        Canvas{ context ,size in
            context.addFilter(.alphaThreshold(min: 0.5,color: .appBlue))
            context.addFilter(.blur(radius: 2))
            
            context.drawLayer { ctx in
                let hour = ctx.resolveSymbol(id: 1)!
                let minute = ctx.resolveSymbol(id: 2)!
                
                ctx.draw(hour, at: CGPoint(x: size.width/2, y: size.height/2))
                ctx.draw(minute, at: CGPoint(x: size.width/2, y: size.height/2))
            }
        }symbols: {
            hoursHandView
                .rotationEffect(.degrees(-90))
                .tag(1)
            
            minutesHandView
                .rotationEffect(.degrees(-90))
                .tag(2)
        }
    }
    
    //MARK: - HoursHandView
    private var hoursHandView: some View{
        Capsule(style: .continuous)
            .fill(LinearGradient(colors: [.appBlue,.appDark], startPoint: .leading, endPoint: .trailing))
            .frame(width: 60,height: 13,alignment: .center)
            .offset(x: 50)
            .rotationEffect(.degrees(hoursAngle))
            .shadow(color: .appBlack, radius: 10,x: -7,y: 5)
    }
    
    //MARK: - MinutesHandView
    private var minutesHandView: some View{
        Capsule(style: .continuous)
            .fill(LinearGradient(colors: [.appBlue,.appDark], startPoint: .leading, endPoint: .trailing))
            .frame(width: 70,height: 7,alignment: .center)
            .offset(x: 55)
            .rotationEffect(.degrees(minutesAngle))
            .shadow(color: .appBlack, radius: 10,x: -7,y: 5)
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

