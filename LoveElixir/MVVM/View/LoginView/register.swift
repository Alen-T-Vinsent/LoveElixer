//
//  register.swift
//  LoveElixir
//
//  Created by Apple  on 05/09/23.
//

import SwiftUI
import PhotosUI

import Firebase
import FirebaseStorage


struct RegisterView:View{
    
    //MARK: Userdetails
    @State var userName:String = ""
    @State var password:String = ""
    @State var name:String = ""
    @State var userBio:String = ""
    @State var userBioLink:String = ""
    @State var userProfilePicData:Data?
    //MARK: ViewProperties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker:Bool = false
    @State var photoItem:PhotosPickerItem?
    @State var showError:Bool = false
    @State var errorMessage:String = ""
    @State var isLoading:Bool = false
    
    
    @State var showAlert = false
    @State var alertTitle = ""
    
    @State var signUpStatus:Bool = false
    
    //MARK: UserDefaults
    @AppStorage("log_status") var logStatus:Bool = false
    @AppStorage("user_profile_url") var profileURL:URL?
    @AppStorage("user_name") var userNameStored:String = ""
    @AppStorage("user_UID") var userUID:String = ""
    var body: some View{
        VStack(spacing:10){
            Text("Let's sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Hello user, have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
        
            //MARK: for small size optimization
            ViewThatFits{
                ScrollView(.vertical,showsIndicators: false) {
                    HelperView()
                }
                HelperView()
            }
            
            //MARK: RegisterButton
            HStack{
                Text("already have an account")
                    .foregroundColor(.gray)
                
                Button("Login Now") {
                    print("dismissed register and shown login")
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
 
        }
        .vAlign(.top)
        .padding(15)
        .alert(alertTitle, isPresented: $showAlert) {
            
            Button {
                if signUpStatus == true{
                    dismiss()
                }
            } label: {
                Text("Ok")
                   
            }
            .foregroundColor(.black)
               
               }
        .overlay(content: {
            LoadingView(show:$isLoading)
        })
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            //MARK: extracting uiimage from PhotoItem
            if let newValue{
                Task{
                    do{
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else{return}
                        
                        //MARK: updating ui on main thread
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    }catch{}
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions:{})
    }
    
    @ViewBuilder
    func HelperView()->some View{
        VStack(spacing:12){
            ZStack{
                if let userProfilePicData,let image = UIImage(data: userProfilePicData){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.blue)
                }
            }
            .frame(width: 85,height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top,25)
            
            
            TextField("Name", text: $name)
                .border(1, .gray.opacity(0.5))
                .textContentType(.emailAddress)
                .padding(.top,25)
                .disableAutocorrection(true)
                            .autocapitalization(.none)
                            
            TextField("Create a unique user name", text: $userName)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .disableAutocorrection(true)
                            .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio,axis: .vertical)
                .frame(minHeight: 100,alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .disableAutocorrection(true)
                            .autocapitalization(.none)
            
            TextField("Bio Link (Optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .disableAutocorrection(true)
                            .autocapitalization(.none)
            
            Button {
                print("sign up  tapped")
                print("sign up  tapped")
                guard let userPic = userProfilePicData else{
                    return
                }
                
                print(type(of: userPic))
                let signUpModel = SignUpModel(name: name, userName: userName, password: password, about: userBio, userPic: userPic)
                signUp(signUpModel: signUpModel)
                
                
            } label: {
                //MARK: login button
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
            }
            .disableWithOpacity(userName == "" || userBio == "" || userName == "" || password == "" || userProfilePicData == nil)
            .padding(.top,10)
            
        }
    }
    
    //MARK: register user
    func registerUser(name:String,userName:String,password:String,about:String,profilePic:Data){
        isLoading = true
        print(#function)
        closeKeyboard()
        print("save data to firebase")
        
        let signUpModel = SignUpModel(name: name, userName: userName, password: password, about: about,userPic: profilePic)
        print(signUpModel)
        
        uploadImageToFirebaseStorage(imageData: signUpModel.userPic) { result in
            switch result {
                case .success(let imageUrl):
                uploadSignUpDataToFirebase(signUpModel: signUpModel, imageUrl: imageUrl)
                case .failure(let error):
                    print("Error uploading image: \(error)")
                isLoading = false
                alertTitle = "failed to upload image try another image"
                showAlert = true
                }
        }
        
    }
    
    //MARK: Displaying Error via Alert
    func setError(_ error:Error)async{
        //MARK: updating ui on main thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    

    func uploadImageToFirebaseStorage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageName = "\(UUID().uuidString).jpg" // Generate a unique name for the image

        let imageRef = storageRef.child("ProfilePictures/\(imageName)")

        let _ = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        completion(.success(downloadURL))
                    } else {
                        if let error = error {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    
    func uploadSignUpDataToFirebase(signUpModel:SignUpModel,imageUrl: URL) {
           let db = Firestore.firestore()
        
               let userDict: [String: Any] = [
                                              "name": signUpModel.name,
                                              "userName": signUpModel.userName,
                                              "password": signUpModel.password,
                                              "about": signUpModel.about,
                                              "userPicURL": imageUrl.absoluteString, // Store the image URL
                                              "id":signUpModel.userName,
                                              "connections":[String]()
                                             ]
   
               
               let docId = userDict["id"]
          
             
               // Create a reference to the document
                   let documentRef = db.collection("Users").document(docId as! String)
               
               // Set data for the document
                      documentRef.setData(userDict) { error in
                          if let error = error {
                              isLoading = false
                              alertTitle = "error occured while creating account"
                              showAlert = true
                              print("Error uploading data: \(error.localizedDescription)")
                          } else {
                              isLoading = false
                              signUpStatus = true
                              print("Data added successfully")
                              alertTitle = "Successfully created an account "
                              showAlert = true
                              
                          }
                      }
       }
    
    
    func checkUsernameExistence(username: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        
        // Query the "Users" collection for documents with matching "userName" field
        db.collection("Users")
            .whereField("userName", isEqualTo: username)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                // Check if any documents with the given username exist
                if let documents = querySnapshot?.documents, !documents.isEmpty {
                    // Username already exists
                    completion(true, nil)
                } else {
                    // Username does not exist
                    completion(false, nil)
                }
            }
    }

    func signUp(signUpModel:SignUpModel) {
        // Assuming signUpModel and imageUrl are already defined
        
        checkUsernameExistence(username: signUpModel.userName) { (usernameExists, error) in
            if let error = error {
                isLoading = false
                alertTitle = "Error checking username existence"
                showAlert = true
                print("Error checking username existence: \(error.localizedDescription)")
                return
            }
            
            if usernameExists{
                isLoading = false
                alertTitle = "Username already exists"
                showAlert = true
                
            } else {
                print(#function)
                print("no user name")
                // Username is unique, proceed to uploadSignUpDataToFirebase
                registerUser(name: signUpModel.name, userName: signUpModel.userName, password: signUpModel.password, about: signUpModel.about, profilePic: signUpModel.userPic)
            }
        }
    }



    
}



//MARK: View extension for UIBuilding
extension View{
    
    //Closing all active keyboards
    func closeKeyboard(){///when signin or signup pressed active keyboard is closed
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    //MARK: Disabling with opacity
    func disableWithOpacity(_ condition:Bool)->some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ alignment:Alignment)->some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    
    func vAlign(_ alignment:Alignment)->some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
    
    //MARK: Custom border view with padding
    func border(_ width:CGFloat,_ color:Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{ RoundedRectangle(cornerRadius: 5,style: .continuous)
                .stroke(color,lineWidth: width)
                
            }
    }
    
    //MARK: Custom fill view with padding
    func fillView(_ color:Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{ RoundedRectangle(cornerRadius: 5,style: .continuous)
                .fill(color)
                
            }
    }

}


struct SignUpModel{
    var name:String
    var userName:String
    var password:String
    var about:String
    var userPic:Data
}


import SwiftUI

struct LoadingView: View {
    @Binding var show:Bool
    var body: some View {
        ZStack{
            if show{
                Group{
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()
                    ProgressView()
                        .padding(15)
                        .background(.white,in:RoundedRectangle(cornerRadius:10,style: .continuous))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}

