//
//  Login.swift
//  LoginTest
//
//  Created by Sam Greenhill on 5/4/23.
//

import SwiftUI

struct Login: View {
    @State var email: String = ""
    @State var password: String = ""

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Login")
                        .font(.system(size: 40, weight: .heavy))
                    //for dark mode adoption
                        .foregroundColor(.primary)

                    Text("Please sign in to continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()

            CustomTextField(image: "envelope", title: "EMAIL", value: $email)

            CustomTextField(image: "lock", title: "PASSWORD", value: $password)
                .padding(.top, 5)

            VStack(alignment: .trailing, spacing: 20) {
                Button {
                    print("test")
                } label: {
                    Text("FORGOT")
                        .fontWeight(.heavy)
                        .foregroundColor(Color.yellow)
                }
                Button {
                    print("test")
                } label: {
                    HStack(spacing: 10) {
                        Text("LOGIN")
                            .fontWeight(.heavy)

                        Image(systemName: "arrow.left")
                            .font(.title)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 35)
                }
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
