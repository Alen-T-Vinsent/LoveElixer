//
//  loginView.swift
//  LoveElixir
//
//  Created by Apple  on 05/09/23.
//
import SwiftUI
import Firebase

struct LoginView: View {
    
    //MARK: AppStorage
    @AppStorage("LOGIN_STATUS") var isLoggedIn:Bool = false
    @AppStorage("USER_NAME") var userName:String = ""


    
    
    //MARK: Userdetails
    @State var uniqueUserName:String = ""
    @State var password:String = ""

    //MARK: View properties
    @State var createAccount:Bool = false
    @State var showError:Bool = false
    @State var errorMessage:String = ""
    @State var isLoading:Bool = false
    
    @State var loginSuccess:Bool = false
    
    //Aelrt
    @State var alertTitle = ""
    @State var showAlert = false

    var body: some View {
        VStack{
            Text("Let's sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("welcome back\n we were waiting for you")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing:12){
                TextField("Your unique Username", text: $uniqueUserName)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .border(1, .gray.opacity(0.5))
                
                Button("Reset password",action:resetPassword)
                .font(.callout)
                .fontWeight(.medium)
                .tint(.black)
                .hAlign(.trailing)
                
                Button {
                    print("signin tapped")
                    
                    
                    isLoading = true
                       checkLoginCredentials(userName: uniqueUserName, password: password) { result in
                           isLoading = false
                           switch result {
                           case .success(let isAuthenticated):
                               if isAuthenticated {
                                   // Login successful
                                   // Navigate to the next screen or perform any required action
                                   print("Login successful")
                                   alertTitle = "Login Successfully found "
                                   showAlert = true
                                   loginSuccess = true
                                   
                               } else {
                                   // Login failed
                                   alertTitle = "Invalid Credentials"
                                   showAlert = true
                                   print("Invalid credentials")
                               }
                           case .failure(let error):
                               alertTitle = "Error"
                               showAlert = true
                               print("Error checking credentials: \(error.localizedDescription)")
                           }
                       }
                    
                    
            
                        
                    
             
                } label: {
                    //MARK: login button
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,10)
            }
            
            //MARK: RegisterButton
            HStack{
                Text("Don't have an account")
                    .foregroundColor(.gray)
                
                Button("Register Now") {
                    print("restier now")
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
 
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            
                LoadingView(show:$isLoading)
     
        })
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            
            Button {
                if loginSuccess{
                    userName = uniqueUserName
                    isLoggedIn = true
                    
                }
            } label: {
                Text("Ok")
                   
            }
            .foregroundColor(.black)
               
               }
        
        
        
        //MARK: Displaying error
        .alert(errorMessage, isPresented: $showError,actions:{})
    }
    
    func loginUser(){
        isLoading = true
        closeKeyboard()
        print("login User")
    }
    
    //MARK: Reset password
    func resetPassword(){
        print("reset password")
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
    
    //MARK: if user found then fetching user data from firestore
    func fetchUser()async throws{
        print("fetch user")
    }


    func checkLoginCredentials(userName: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        isLoading = true
        let db = Firestore.firestore()
        
        // Query Firestore to find a user with the provided userName
        db.collection("Users")
            .whereField("userName", isEqualTo: userName)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        // User with the provided userName exists in Firestore
                        // Check if the password matches
                        let document = documents[0]
                        let storedPassword = document.data()["password"] as? String ?? ""
                        if storedPassword == password {
                            // Passwords match, login successful
                           
                            completion(.success(true))
                        } else {
                            // Passwords do not match
                            
                            completion(.success(false))
                        }
                    } else {
                        // User with the provided userName does not exist in Firestore
                       
                        completion(.success(false))
                        
                    }
                }
            }
    }

    
}



