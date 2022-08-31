//
//  ContentView.swift
//  WhatsWithoutAdd
//
//  Created by Bruno Sabadini on 29/06/22.
//

import SwiftUI
import WebKit



extension InformNumberView{
  @MainActor class ViewModel: ObservableObject{
    @Published var pasteBoardContents: String = ""
    @Published var DDD: String = ""
    @Published var DDI: String = "55"
    @Published  var isShowingWebView = false
    @Published  var isShowingFixNumberMessage = false
    @Published  var isShowingFixDDDMessage = false
    let PasteboardAcess = UIPasteboard.general
    let DDDList = [11,12,13,14,15,16,17,18,19,21,22,24,27,28,31,32,33,34,35,37,38,41,42,43,44,45,46,47,48,49,51,53,54,55,61,62,63,64,65,66,67,68,69,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,92,93,94,95,96,97,98,99]
    
    let colorStops: [Gradient.Stop] = [
      .init(color: Color.white, location: 0.15),
      .init(color: Color.gray, location: 0.4),
      .init(color: Color.white, location: 0.8)
    ]
    
    func checkIfNumberContainsDDD(){
      if pasteBoardContents.prefix(2) == DDD.prefix(2) && pasteBoardContents.prefix(1) != "9" {
        pasteBoardContents = pasteBoardContents[2..<20]
      }
    }
    
    func oppeningAppInitialValidation(){
      
      if DDI.prefix(1) != "+" {
        DDI.insert("+", at: DDI.startIndex)
      }
      
      let DDDandDDIcheck:String = String(pasteBoardContents.prefix(4))
      
      if DDDandDDIcheck != "5555"{
        if String(pasteBoardContents.prefix(2)) == "55" {
          pasteBoardContents = pasteBoardContents.replacingOccurrences(of: "55", with: "222")
          print("aaa")
        }}
      
      else{
        DDI = "+55"
        DDD = "55"
        
      }
      
      if let pasteBoardContent = PasteboardAcess.string {
        
        pasteBoardContents = pasteBoardContent.filter("0123456789".contains)
        let DDDandDDIcheck:String = String(pasteBoardContents.prefix(2))
        
        
        let DDDlistToStringList = DDDList.map(String.init)
        
        
        if  DDDlistToStringList.contains(DDDandDDIcheck){
          DDD = DDDandDDIcheck
        }
        
        if (pasteBoardContent.count < 10) {
          isShowingFixNumberMessage = true
        }
      }
      checkIfNumberContainsDDD()}
    
    func validatePhoneNumber(){
      
      oppeningAppInitialValidation()
      if DDD == "DDD" {
        isShowingFixDDDMessage = true
      }
      else {
        isShowingFixDDDMessage = false}
    }
  }
  struct WhatsAppWebView : UIViewRepresentable {
    
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
      
      return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
      uiView.load(request)
      
    }
    
  }
  
  struct ButtonsStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .padding()
        .background(.ultraThinMaterial)
        .foregroundColor(Color.black)
        .clipShape(Capsule())
        .shadow(color: .gray, radius: 10)
    }
  }
  
  
  struct TextFieldsStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
      configuration
        .padding(10)
        .background(.ultraThinMaterial)
        .cornerRadius(200)
        .shadow(color: .gray, radius: 10)
    }
  }
}


struct InformNumberView: View {
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    NavigationView{
      ZStack {
        Rectangle()
          .fill(LinearGradient(stops: viewModel.colorStops, startPoint: .top, endPoint: .bottom))
          .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
          )
          .ignoresSafeArea()
        VStack {
          HStack{
            Image(systemName: "flag")
            TextField("aaaaa", text: $viewModel.DDI)  .textFieldStyle(TextFieldsStyle())
            Image("state").resizable()
              .frame(width:32, height: 24)
            TextField("DDD", text: $viewModel.DDD)  .textFieldStyle(TextFieldsStyle())
          }
          Spacer()
            .frame(height: 35)
          HStack{
            Image(systemName: "phone")
            TextField("Phone Number", text: $viewModel.pasteBoardContents)  .textFieldStyle(TextFieldsStyle())
            
          }.onChange(of: viewModel.pasteBoardContents, perform: {i in
            viewModel.checkIfNumberContainsDDD()})
          if(viewModel.isShowingFixNumberMessage == true){
            Text("Your number seems too short")}
          
          if(viewModel.isShowingFixDDDMessage == true){
            Text("Dont forget to inform DDD")}
          Spacer()
          HStack{
            Button("Refresh copied/cropped number", action: {
              viewModel.validatePhoneNumber()
            })
              .padding()
              .buttonStyle(ButtonsStyle())
          }
          NavigationLink(destination: WhatsAppWebView(request: URLRequest(url: URL(string: "http://wa.me/" + viewModel.DDI + viewModel.DDD + viewModel.pasteBoardContents)!)), isActive: $viewModel.isShowingWebView){
            HStack{
              Button("Go to Whatsapp", action: {
                viewModel.isShowingWebView = true
              })
                .buttonStyle(ButtonsStyle())
            }
            .padding()
          }
        }
      }
      .onAppear(perform: {viewModel.oppeningAppInitialValidation()})
      
    }
  }
}







struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    InformNumberView()
  }
}

struct WebView_Previews : PreviewProvider {
  static var previews: some View {
    InformNumberView.WhatsAppWebView(request: URLRequest(url: URL(string: "http://wa.me/")!))
  }
}






