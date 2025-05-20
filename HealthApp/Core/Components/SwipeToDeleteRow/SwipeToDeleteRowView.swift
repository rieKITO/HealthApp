//
//  SwipeToDeleteRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 21.05.2025.
//

import SwiftUI

struct SwipeToDeleteRowView<Content: View>: View {
    
    // MARK: - State
    
    @State
    private var offset: CGFloat = 0
    
    @State
    private var isDeleteButtonVisible = false
    
    @State
    private var isDeleting = false
    
    // MARK: - Private Properties
    
    private let buttonWidth: CGFloat = 60
    
    private let buttonPadding: CGFloat = 8
    
    private let rowHeight: CGFloat = 60
    
    // MARK: - Init Properties
    
    let content: Content
    
    let deleteAction: () -> Void
    
    let onTap: () -> Void
    
    // MARK: - Init
    
    init(
        @ViewBuilder content: () -> Content,
        deleteAction: @escaping () -> Void,
        onTap: @escaping () -> Void
    ) {
        self.content = content()
        self.deleteAction = deleteAction
        self.onTap = onTap
    }
    
    // MARK: - Body

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                deleteButton
                    .opacity(isDeleting ? 0 : (isDeleteButtonVisible ? 1 : 0))
            }
            .frame(height: rowHeight)
            .background(Color.theme.background)
            content
                .frame(height: rowHeight)
                .padding(.trailing, isDeleteButtonVisible ? (buttonPadding + 10) : 0)
                .background(Color.theme.background)
                .offset(x: offset)
                .gesture(dragGesture)
                .simultaneousGesture(tapGesture)
        }
        .frame(height: rowHeight)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .opacity(isDeleting ? 0 : 1)
        .scaleEffect(isDeleting ? 0.95 : 1)
        .animation(.easeInOut(duration: 0.35), value: isDeleting)
        .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: offset)
    }

}

// MARK: - Private Methods

private extension SwipeToDeleteRowView {
    
    private func resetOffset() {
        withAnimation {
            offset = 0
            isDeleteButtonVisible = false
        }
    }
    
}

// MARK: - Subviews

private extension SwipeToDeleteRowView {
    
    private var deleteButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.35)) {
                offset = -UIScreen.main.bounds.width
                isDeleteButtonVisible = false
                isDeleting = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                deleteAction()
            }
        }) {
            Image(systemName: "trash")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: buttonWidth, height: buttonWidth)
                .background(Circle().fill(Color.red))
                .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.trailing, buttonPadding)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 15)
            .onChanged { gesture in
                if gesture.translation.width < 0 {
                    offset = max(-(buttonWidth + buttonPadding), gesture.translation.width)
                    isDeleteButtonVisible = offset < -buttonWidth / 2
                } else if gesture.translation.width > 0 && offset < 0 {
                    offset = min(0, gesture.translation.width + offset)
                    if offset > -buttonWidth / 2 {
                        isDeleteButtonVisible = false
                    }
                }
            }
            .onEnded { _ in
                if isDeleteButtonVisible {
                    offset = -(buttonWidth + buttonPadding)
                } else {
                    resetOffset()
                }
            }
    }

    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                if isDeleteButtonVisible {
                    resetOffset()
                } else {
                    onTap()
                }
            }
    }
    
}

