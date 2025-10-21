import SwiftUI

struct JournalPromptView: View {
    
    var promptText: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var journalText: String = ""
    @State private var selectedMood: Int? = nil
    
    var body: some View {
            VStack(spacing: 20) {
                
                HStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .padding(3)
                                .foregroundStyle(.white)
                        }
                        .glassEffect(.clear
                            .tint(Color.gray.opacity(0.8))
                            .interactive()
                        )
                        .clipShape(Circle())
                        .buttonStyle(.glass)
                    }
                    .frame(width: 56, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.top)
                    
                    Text("Prompt Journal")
                        .font(.system(size: 28, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                    
                    HStack {
                        Button(action: {/*action*/() }) {
                            Image(systemName: "checkmark")
                                .font(.title)
                                .padding(3)
                                .foregroundStyle(.white)
                        }
                        .glassEffect(.clear
                            .tint(Color.gray.opacity(0.8))
                            .interactive()
                        )
                        .clipShape(Circle())
                        .buttonStyle(.glass)
                    }
                    .frame(width: 56, alignment: .trailing)
                    .padding(.horizontal, 10)
                    .padding(.top)
                    
                }
                .padding(.horizontal)
                .padding(.top)
                
                Text("How was your day?")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                
                HStack(spacing: 16) {
                    moodButton(index: 0, imageName: "Image 3")
                    moodButton(index: 1, imageName: "Image 4")
                    moodButton(index: 2, imageName: "Image 1")
                    moodButton(index: 3, imageName: "Image 2")
                }
                .padding(.horizontal)
                
                Spacer(minLength: 10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Prompt of day")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(promptText)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                )
                .cornerRadius(14)
                .padding(.horizontal)
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.gray.opacity(0.70))
                    
                    TextEditor(text: $journalText)
                        .padding(12)
                        .scrollContentBackground(.hidden)
                        .foregroundColor(.primary)
                        .font(.body)
                        .frame(minHeight: 350)
                    
                    if journalText.isEmpty {
                        Text("Write your thoughts...")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .font(.body)
                    }
                    
                }
                .frame(height: 340)
                .padding(.horizontal)
                .padding(.top, 40)
                
                Spacer()
            }
            .padding(.bottom)
            .appBackground()
        
        .navigationBarBackButtonHidden(true)
    }
        
    
    
    @ViewBuilder
    private func moodButton(index: Int, imageName: String) -> some View {
        let isSelected = selectedMood == index
        Button {
            selectedMood = index
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(isSelected ? Color.blue.opacity(0.9) : Color.white.opacity(0.25), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: isSelected ? Color.blue.opacity(0.25) : Color.black.opacity(0.1), radius: isSelected ? 8 : 4, x: 0, y: 2)
                .scaleEffect(isSelected ? 1.06 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    JournalPromptView(promptText: "Preview of today’s prompt")
}
