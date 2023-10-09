//
//  CustomTextField.swift
//  LoginTest
//
//  Created by Sam Greenhill on 5/4/23.
//

import SwiftUI
/*
 To create a custom textfield we create a zstack that contains a text and a textfield overlaid on the text. when the user starts typing the text moves up in an animated manner and the whole of it is wrapped into an hstack with the corresponding image.
 */

/*
 Why we use frame?:
 Since each image font size is 22, the width will be different for each one. So if we use the frame, it will create an outer layer with the same width and the image is wrapped into it. This way the aligment will be proper.
 */

struct CustomTextField: View {

    // Fields
    var image: String
    var title: String
    @Binding var value: String
    @Namespace private var animation


    var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .bottom) {
                Image(systemName: image)
                    .font(.system(size: 22))
                    .foregroundColor(value == "" ? .gray : .primary)
                    .frame(width: 35)

                VStack(alignment: .leading, spacing: 6) {
                    if value != "" {
                        Text(title)
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                            .matchedGeometryEffect(id: title, in: animation)
                    }

                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                        if value == "" {
                            Text(title)
                                .font(.caption)
                                .fontWeight(.heavy)
                                .foregroundColor(.gray)
                                .matchedGeometryEffect(id: title, in: animation)
                        }
                        if title == "PASSWORD" {
                            SecureField("", text: $value)
                        } else {
                            TextField("", text: $value)
                            // For phone number
                                .keyboardType(title == "PHONE NUMBER" ? .numberPad : .default)
                        }
                    }
                }
            }
            if value == "" {
                Divider()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white.opacity(value != "" ? 1 : 0))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
        .padding(.horizontal)
        .padding(.top)
        .animation(.linear.speed(3), value: value)
    }
}

//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField()
//    }
//}
