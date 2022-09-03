import SwiftUI
import Firebase

struct GameModal: View {
    @Environment(\.presentationMode) var presentationMode
    @State var email = ""
       @State var password = ""

       var body: some View {
           VStack {
               TextField("Email", text: $email)
               SecureField("Password", text: $password)
               Button(action: { login() }) {
                   Text("Sign in")
               }
           }
           .padding()
       }

       func login() {
           Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
               if error != nil {
                   print(error?.localizedDescription ?? "")
               } else {
                   print("success")
               }
           }
       
}
}

