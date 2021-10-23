//
//  ContentView.swift
//  EnviroShop
//
//  Created by Isaac Adams on 10/23/21.
//

import SwiftUI


//Loads the home screen
struct ContentView: View {
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView{
            
            
            
            ZStack{
                
                NavigationLink(destination: BarcodeView(), tag: "Barcode", selection: $selection ) {EmptyView()}
                NavigationLink(destination: ProductIdView(), tag: "ProductId", selection: $selection ) {EmptyView()}
                
                //Background colors
                LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
                
                VStack{
                    
                    //App Label
                    Text("EcoShop")
                        .frame(width: 400, height: 60)
                        .background(Color.egreen)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                    
                    
                    //Search by label
                    Text("Search By...")
                        .frame(width: 400, height: 60)
                        .background(Color.eblue)
                        .padding(.bottom, 100)
                    
                    //Barcode Search Button
                    Button(action:{
                        self.selection = "Barcode"
                    },
                    label: {
                        Text("BARCODE")
                            .foregroundColor(Color.black)
                    })
                    .frame(width: 250, height: 60)
                    .background(Color.egreen)
                    .cornerRadius(10)
                    .padding(.bottom, 100)
                    
                    Button(action:{
                        self.selection = "ProductId"
                    },
                    label: {
                        Text("PRODUCT ID")
                            .foregroundColor(Color.black)
                    })
                    .frame(width: 250, height: 60)
                    .background(Color.egreen)
                    .cornerRadius(10)
                    
                    
                }.padding(.bottom, 270)
                
            }
        }
    }
}

struct BarcodeView: View {
    @State private var selection: String? = nil
    
    var body: some View{
        NavigationView{
            ZStack{
                //Background colors
                LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            }
        }
    }
}

struct ProductIdView: View {
    @State private var selection: String? = nil
    
    var body: some View{
        NavigationView{
            ZStack{
                //Background colors
                LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
