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
                        .frame(width: 390, height: 100).padding(.bottom, 100)
                    
                    
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
    
    
    var body: some View{
        ZStack (alignment: .top){
            //Background colors
            LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            
            NavigationLink(destination: ImagePicker(show: $imagePicker, image: $imageData, source: source), isActive: $imagePicker){
                EmptyView()
            }
            
            NavigationLink(destination: ProductIdView(), tag: "ProductId", selection: $selection ) {EmptyView()}
            
            VStack{
                //Top Banner
                Image("Banner")
                    .resizable()
                    .frame(width: 390, height: 100).padding(.bottom, 50)
                
                if imageData.count != 0 {
                    Image(uiImage: UIImage(data: self.imageData)!)
                        .resizable()
                        .frame(width: 350, height: 350)
                        .foregroundColor(Color.purple)
                        //.rotationEffect(.degrees())
                        .padding(.bottom, 20)
                }
                else{
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .foregroundColor(Color.egreen)
                        .padding(.bottom, 20)
                }
                
                Button(action: {
                    self.show.toggle()
                }){
                    Text("Take a Photo")
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
                            
                            print(results.count)
                            
                            // Loop through the found results
                            for result in results {
                                
                                // Cast the result to a barcode-observation
                                if let barcode = result as? VNBarcodeObservation {
                                    
                                    // Print barcode-values
                                    print("Symbology: \(barcode.payloadStringValue!)")
                                    
                                    
                                }
                            }
                            
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
            
            //Background colors
            LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            
            VStack{
                
                //Top Banner
                Image("Banner")
                    .resizable()
                    .frame(width: 390, height: 100).padding(.bottom, 100)
                
                Text("Enter Product ID:")
                    .foregroundColor(Color.black)
                TextField("Product",
                          text: $id,
                          onCommit:{
                            var num = Int(id)
                            
                            if(num == nil){
                                errorLabel = "Please enter a valid UPC";
                            }
                            else if(id.count != 12){
                                errorLabel = "Please enter a valid UPC"
                            }
                            else{
                                print(num!)
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
    
    var idString: String
    var body: some View{

        
        ZStack(alignment: .top){
            
            //Background colors
            LinearGradient(gradient: Gradient(colors: [.ecream,.white]), startPoint: .leading, endPoint: .bottom).ignoresSafeArea(edges: [.top, .bottom])
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(idString: "01234565")
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
