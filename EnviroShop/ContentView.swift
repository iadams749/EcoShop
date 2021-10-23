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
    @State private var id: String = ""
    @State private var isEditing = false
    @State private var errorLabel: String = ""
    
    var body: some View{
        NavigationView{
            ZStack (alignment: .top) {
                //Background colors
                LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
                
                VStack{
                    
                    //Top Banner
                    Image("Banner")
                        .resizable()
                        .frame(width: 390, height: 100).padding(.bottom, 100)
                    
                    Text("Enter Product ID:")
                    TextField("Product",
                              text: $id,
                              onCommit:{
                                let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
                                
                              })
                        .frame(width: 300, height: 50)
                        .background(Color.egreen)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .cornerRadius(10)
                    Text(errorLabel)
                }
            }
            .ignoresSafeArea(edges: .top)

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductIdView()
    }
}
