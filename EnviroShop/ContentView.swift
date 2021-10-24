//
//  ContentView.swift
//  EnviroShop
//
//  Created by Isaac Adams on 10/23/21.
//

import SwiftUI
import Foundation
import CoreML
import Vision


//Loads the home screen
struct ContentView: View {
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView{
            
            
            
            ZStack (alignment: .top){
                
                NavigationLink(destination: BarcodeView(), tag: "Barcode", selection: $selection ) {EmptyView()}
                NavigationLink(destination: ProductIdView(), tag: "ProductId", selection: $selection ) {EmptyView()}
                
                //Background colors
                LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
                
                VStack{
                    
                    
                    //Top Banner
                    Image("Banner")
                        .resizable()
                        .frame(width: 400, height: 100).padding(.bottom, 0)
                        .border(Color.black, width: 3)
                    
                    VStack(spacing: 40){
                        
                        //Search by label
                        Text("What Would You Like To Search By?")
                            .fontWeight(.bold)
                            .frame(width: 400, height: 60)
                            .background(Color.egreen)
                            .cornerRadius(10)
                        
                        //Barcode Search Button
                        Button(action:{
                            self.selection = "Barcode"
                        },
                        label: {
                            Text("BARCODE")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                        })
                        .frame(width: 250, height: 60)
                        .background(Color.eblue)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        
                        //Product ID Search Button
                        Button(action:{
                            self.selection = "ProductId"
                        },
                        label: {
                            Text("PRODUCT ID")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                        })
                        .frame(width: 250, height: 60)
                        .background(Color.eblue)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }.padding(.bottom, 40)
                    .padding(.top, -8)
                    //.background(Color.gray.opacity(0.5))
                    .shadow(radius: 10)
                    
                    Image("Logo")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    
                }
                
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

struct BarcodeView: View {
    @State private var selection: String? = nil
    @State var imageData: Data = .init(capacity: 0)
    @State var show = false
    @State var imagePicker = false
    @State var source : UIImagePickerController.SourceType = .photoLibrary
    @State var upc = ""
    @State var imageName = Image("model1")
    
    
    var body: some View{
        ZStack (alignment: .top){
            //Background colors
            LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            
            NavigationLink(destination: ImagePicker(show: $imagePicker, image: $imageData, source: source), isActive: $imagePicker){
                EmptyView()
            }
            
            NavigationLink(destination: ProductIdView(), tag: "ProductId", selection: $selection ) {EmptyView()}
            
            NavigationLink(destination: ProfileView(idString: upc, pic: imageName, brand: "Shein", envSus: 1, labSus: 1, aniSus: 3, price: 5, origin: "China"), tag: "Profile", selection: $selection ) {EmptyView()}
            
            VStack{
                //Top Banner
                Image("Banner")
                    .resizable()
                    .frame(width: 390, height: 100)
                    .border(Color.black, width: 3)
                
                if imageData.count != 0 {
                    Image(uiImage: UIImage(data: self.imageData)!)
                        .resizable()
                        .frame(width: 350, height: 350)
                        .foregroundColor(Color.purple)
                        //.rotationEffect(.degrees())
                        .padding(.bottom, 20)
                        .padding(.top, 50)
                }
                else{
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .foregroundColor(Color.egreen)
                        .padding(.bottom, 20)
                        .padding(.top, 50)
                }
                
                Button(action: {
                    self.show.toggle()
                }){
                    Text("Take a Photo")
                        .fontWeight(.bold)
                        .frame(width: 250, height: 100, alignment: .center)
                        .background(Color.eblue)
                        .foregroundColor(Color.ecream)
                        .cornerRadius(10)
                }.actionSheet(isPresented: $show){
                    ActionSheet(title: Text("Take a photo or select from photo library"), message: Text(""), buttons:
                                    [.default(Text("Photo Library"), action: {
                                        self.source = .photoLibrary
                                        self.imagePicker.toggle()
                                    }),.default(Text("Camera"), action: {
                                        self.source = .camera
                                        self.imagePicker.toggle()
                                    })]
                    )
                }.padding(.bottom, 20)
                
                Button(action: {
                    if imageData.count != 0{
                        
                        // Create a barcode detection-request
                        let barcodeRequest = VNDetectBarcodesRequest(completionHandler: { request, error in
                            
                            guard let results = request.results else { return }
                            
                            if results.count > 0{
                                if let barcode = results[0] as? VNBarcodeObservation {
                                    upc = barcode.payloadStringValue!
                                    imageName = Image("model1")
                                    
                                    selection = "Profile"
                                }
                            }
                            
                            // Loop through the found results
                            /*for result in results {
                             
                             // Cast the result to a barcode-observation
                             if let barcode = result as? VNBarcodeObservation {
                             
                             // Print barcode-values
                             print("Symbology: \(barcode.payloadStringValue!)")
                             
                             
                             }
                             }*/
                            
                        })
                        
                        // Create an image handler and use the CGImage your UIImage instance.
                        guard let image = UIImage(data: self.imageData)!.cgImage else { return }
                        let handler = VNImageRequestHandler(cgImage: image, options: [:])
                        
                        // Perform the barcode-request. This will call the completion-handler of the barcode-request.
                        guard let _ = try? handler.perform([barcodeRequest]) else {
                            return print("Could not perform barcode-request!")
                        }
                        
                    }
                }){
                    Text("Submit Photo")
                        .fontWeight(.bold)
                        .frame(width: 250, height: 100, alignment: .center)
                        .background(Color.eblue)
                        .foregroundColor(Color.ecream)
                        .cornerRadius(10)
                    
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct ProductIdView: View {
    @State private var selection: String? = nil
    @State private var id: String = ""
    @State private var isEditing = false
    @State private var errorLabel: String = ""
    
    var body: some View{
        ZStack (alignment: .top) {
            
            NavigationLink(destination: BarcodeView(), tag: "Barcode", selection: $selection ) {EmptyView()}
            
            NavigationLink(destination: ProfileView(idString: id, pic: Image("model2"), brand: "Reformation", envSus: 5, labSus: 4, aniSus: 2, price: 38, origin: "Los Angeles"), tag: "Profile", selection: $selection ) {EmptyView()}
            
            //Background colors
            LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            
            VStack{
                
                //Top Banner
                Image("Banner")
                    .resizable()
                    .frame(width: 390, height: 100)
                    .border(Color.black, width: 3)
                
                Text("Enter Product ID:")
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding(.top, 100)
                TextField("Product",
                          text: $id,
                          onCommit:{
                            var num = Int(id)
                            
                            if(num == nil){
                                errorLabel = "Please enter a valid UPC";
                            }
                            else if(id.count != 8){
                                errorLabel = "Please enter a valid UPC"
                            }
                            else{
                                selection = "Profile"
                            }
                          })
                    .frame(width: 300, height: 50)
                    .background(Color.egreen)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .cornerRadius(10)
                Text(errorLabel)
                    .foregroundColor(Color.red)
                    .fontWeight(.bold)
                    .padding(.top, 20)
            }
            .ignoresSafeArea(edges: .top)
            
        }
    }
}

struct ProfileView: View{
    @State private var selection: String? = nil
    @State private var imageName = Image("model1")
    
    var idString: String
    var pic: Image
    var brand: String
    var envSus: Int
    var labSus: Int
    var aniSus: Int
    var price: Int
    var origin: String
    
    var body: some View{
        
        
        ZStack(alignment: .top){
            
            //Background colors
            LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            
            VStack{
                //Top Banner
                Image("Banner")
                    .resizable()
                    .frame(width: 390, height: 100)
                    .border(Color.black, width: 3)
                
                Text("UPC: \(idString)")
                    .fontWeight(.bold)
                    .font(.system(size: 40))
                    .foregroundColor(Color.black)
                    .padding(.top, 20)
                pic
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(16)
                    .foregroundColor(Color.gray)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 4))
                    .padding(.bottom, 20)
                
                let sum = envSus + labSus + aniSus
                
                
                HStack(spacing: 15){
                    Image(systemName: "leaf")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.egreen)
                        .shadow(color: .egreen, radius: 4)
                    if sum >= 5 {
                        Image(systemName: "leaf")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.egreen)
                            .shadow(color: .egreen, radius: 4)
                    }
                    
                    if sum >= 8 {
                        Image(systemName: "leaf")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.egreen)
                            .shadow(color: .egreen, radius: 4)
                    }
                    
                    if sum >= 11 {
                        Image(systemName: "leaf")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.egreen)
                            .shadow(color: .egreen, radius: 4)
                    }
                    
                    if sum >= 14 {
                        Image(systemName: "leaf")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.egreen)
                            .shadow(color: .egreen, radius: 4)
                    }
                }
                .padding(.bottom, 10)
                
                NavigationLink(destination: BarcodeView(), tag: "Barcode", selection: $selection ) {EmptyView()}
                NavigationLink(destination: SimilarItemsView(idString: "01234565", pic: imageName, brand: "Shein", envSus: 1, labSus: 1, aniSus: 3, price: 5, origin: "China"), tag: "Similar", selection: $selection ) {EmptyView()}
                
                VStack(alignment: .leading, spacing: 10){
                    Text("Sustainability Report:")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                    Text("Brand: \(brand)")
                        .foregroundColor(.black)
                    Text("Environmental Sustainability: \(envSus)/5")
                        .foregroundColor(.black)
                    Text("Labor Sustainability: \(labSus)/5")
                        .foregroundColor(.black)
                    Text("Animal Sustainability: \(aniSus)/5")
                        .foregroundColor(.black)
                    Text("Price: $\(price)")
                        .foregroundColor(.black)
                    Text("Location of Origin: \(origin)")
                        .foregroundColor(.black)
                    
                }
                .background(Color.white.opacity(0.3))
                .padding(.trailing, 100)
                
                VStack(spacing: 40){
                    Button(action:{
                        self.selection = "Similar"
                    },
                    label: {
                        Text("See Similar Items")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                    })
                    .frame(width: 200, height: 30)
                    .background(Color.eblue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }.padding(.bottom, 40)
                .padding(.top, 10)
                .shadow(radius: 10)
            }
            
        }
        .ignoresSafeArea(edges: .top)
    }
}


struct SimilarItemsView: View{
    @State private var selection: String? = nil
    @State private var imageName = Image("model1")
    
    var idString: String
    var pic: Image
    var brand: String
    var envSus: Int
    var labSus: Int
    var aniSus: Int
    var price: Int
    var origin: String
    
    var body: some View{
        
        
        ZStack(alignment: .top){
            
            //Background colors
            LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            
            VStack{
                //Top Banner
                Image("Banner")
                    .resizable()
                    .frame(width: 390, height: 100)
                    .border(Color.black, width: 3)
                
                Text("UPC: \(idString)")
                    .fontWeight(.bold)
                    .font(.system(size: 40))
                    .foregroundColor(Color.black)
                    .padding(.top, 20)
                pic
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(16)
                    .foregroundColor(Color.gray)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 4))
                    .padding(.bottom, 20)
                
                let sum = envSus + labSus + aniSus
                
                
                HStack(spacing: 15){
                    Image(systemName: "leaf")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.egreen)
                        .shadow(color: .egreen, radius: 4)
                    if sum >= 5 {
                        Image(systemName: "leaf")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.egreen)
                            .shadow(color: .egreen, radius: 4)
                    }
                    
                    if sum >= 8 {
                        Image(systemName: "leaf")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.egreen)
                            .shadow(color: .egreen, radius: 4)
                    }
                    
                    if sum >= 11 {
                        Image(systemName: "leaf")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.egreen)
                            .shadow(color: .egreen, radius: 4)
                    }
                    
                    if sum >= 14 {
                        Image(systemName: "leaf")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.egreen)
                            .shadow(color: .egreen, radius: 4)
                    }
                }
                .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 10){
                    Text("Sustainability Report:")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                    Text("Brand: \(brand)")
                        .foregroundColor(.black)
                    Text("Environmental Sustainability: \(envSus)/5")
                        .foregroundColor(.black)
                    Text("Labor Sustainability: \(labSus)/5")
                        .foregroundColor(.black)
                    Text("Animal Sustainability: \(aniSus)/5")
                        .foregroundColor(.black)
                    Text("Price: $\(price)")
                        .foregroundColor(.black)
                    Text("Location of Origin: \(origin)")
                        .foregroundColor(.black)
    
                }
                .background(Color.white.opacity(0.3))
                .padding(.trailing, 100)
                
            }
            
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductIdView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var show : Bool
    @Binding var image: Data
    var source : UIImagePickerController.SourceType
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>){
        
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        var parent : ImagePicker
        init(parent1: ImagePicker){
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            let data = image.pngData()
            self.parent.image = data!
            self.parent.show.toggle()
            
        }
    }
    
}
