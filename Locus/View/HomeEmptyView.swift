//
//  HomeEmptyView.swift
//  Locus
//
//  Created by Hafiz Rahmadhani on 17/10/25.
//

import SwiftUI

struct HomeEmptyView: View {
    
    @State private var promptView: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Locus")
                    .font(.largeTitle)
                    .bold()
                //.padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                Button {
                    promptView = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(10)
                        .foregroundStyle(.white)
                }
                .glassEffect(.clear
                    .tint(Color.gray.opacity(0.6))
                    .interactive()
                )
                .clipShape(Circle())
                .padding(.horizontal, 20)
                
            }
            Spacer()
            

            VStack(alignment: .leading) {
                Text("Oh no... Your Journal is empty!")
                    .bold()
                    .font(.title3)
                    .foregroundStyle(.white)

                Text("Do you want to update your day? See the prompt of the day!")
                    .foregroundStyle(.white)

                Text("Click on “+” to see more")
                    .foregroundStyle(.white)
            }
            .padding()
            .frame(width: 350)
            .glassEffect(
                .clear
                .tint(Color.gray.opacity(0.6))
                .interactive(),
                in: RoundedRectangle(cornerRadius: 10)
            )
            
            Spacer()
        }
        .navigationDestination(isPresented: $promptView, destination: {
            PromptView()
        })
        .appBackground()
    }
}

#Preview {
    HomeEmptyView()
}
