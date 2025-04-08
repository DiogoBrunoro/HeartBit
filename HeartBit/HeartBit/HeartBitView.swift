import SwiftUI

struct HeartBitView: View {
    @State private var showAlert = false
    @State private var isButtonEnabled = true
    @State private var timeRemaining = 5
    @State private var timerRunning = false
    @State private var showSheetCall = false
    
    @StateObject var vm = ViewModel()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let tempo2 = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(.backgroundColor1).edgesIgnoringSafeArea(.all)
            
            VStack {
                Button(action: {
                    resetTimer()
                    showAlert = true
                    timerRunning = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        if showAlert {
                            resetTimer()
                            showAlert = false
                            showSheetCall = true
                        }
                    }
                }) {
                    Image(.heart)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.black, lineWidth: 15)
                        )
                        .shadow(radius: 10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Alerta de Emergência"),
                        message: Text("Você pressionou o botão de emergência.\nTempo restante: \(timeRemaining) segundos"),
                        dismissButton: .default(Text("CANCELAR"))
                    )
                }
                
                Text("\(vm.bpms.first?.batimento ?? 0) BPMs")
                    .padding(.top, 30)
                    .font(.title)
                
                Button(action: {}) {
                    Text("Inicia atividade")
                        .padding([.top, .bottom], 10)
                        .padding([.leading, .trailing], 60)
                        .foregroundColor(.white)
                        .background(Color.vermelhoRed)
                        .cornerRadius(30)
                        .font(.title)
                }
                .padding([.top, .bottom], 30)
                
            }
            .sheet(isPresented: $showSheetCall) {
                sheetView()
            }
        }
        .onReceive(tempo2){_ in
            print("updating")
            vm.fetch()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 && timerRunning {
                timeRemaining -= 1
            }
        }
    }
    
    func resetTimer() {
        timeRemaining = 5
        timerRunning = true
    }
}

struct sheetView: View{
    @State private var offset: CGFloat = 0
    var body: some View{
        ZStack {
            Color(.backgroundColor1).edgesIgnoringSafeArea(.all)
            VStack{
                Image(systemName: "message.badge.filled.fill.rtl")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.vermelhoRed)
                    .frame(width: 100, height: 100)
                    .offset(x: offset)
                    .onAppear {
                        withAnimation(
                            Animation.linear(duration: 0.1)
                                .repeatForever(autoreverses: true)
                        ) {
                            offset = 10
                        }
                    }
                
                Text("Mensagem de Emergência Enviada")
                    .font(.largeTitle)
                    .foregroundColor(.vermelhoRed)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
            }
        }
    }
}

#Preview {
    HeartBitView()
}
