//
//  OldestPhotosView.swift
//  SideMenu-Example
//
//  Created by Vidhyadharan Mohanram on 23/06/19.
//  Copyright © 2019 Vid. All rights reserved.
//

import SwiftUI
import SFSafeSymbols

struct OldestPhotosView: View, CenterView {
    @Binding var leftMenuState: Bool
    @Binding var rightMenuState: Bool
    
    @ObjectBinding var viewModel = PhotosViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                containedView()
            }
            .navigationBarTitle("Oldest", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    withAnimation {
                        self.leftMenuState.toggle()
                    }
                }, label: {
                    Image(systemName: SFSymbol.lineHorizontal3.rawValue)
                        .accentColor(.blue)
                        .imageScale(.large)
                }),
                trailing: Button(action: {
                    withAnimation {
                        self.rightMenuState.toggle()
                    }
                }, label: {
                    Image(systemName: SFSymbol.lineHorizontal3.rawValue)
                        .accentColor(.red)
                        .imageScale(.large)

                })
            )
        }
    }
    
    func containedView() -> AnyView {
        let view: AnyView
        switch viewModel.state {
        case .loading:
            view = AnyView(List {
                ForEach(1...3) { row in
                    ListPhotoRow(shouldShimmer: true)
                }
            })
        case .completedWithNoData:
            view = AnyView(Text("No photos"))
        case .completed(let photos):
            view = AnyView(List(photos) { photo in
                ListPhotoRow(photo: photo)
            })
        case .failed(let errorMessage):
            view = AnyView(Text(errorMessage)
                .lineLimit(nil)
                .multilineTextAlignment(.center))
        }
        
        return view
    }
    
    // MARK: - Private
    
    private func fetchData() {
        self.viewModel.fetchPhotos(orderBy: .oldest)
    }
    
    init(leftMenuState: Binding<Bool>? = nil, rightMenuState: Binding<Bool>? = nil) {
        self.$leftMenuState = leftMenuState ?? .constant(false)
        self.$rightMenuState = rightMenuState ?? .constant(false)
        fetchData()
    }
}

#if DEBUG
struct OldestPhotosView_Previews : PreviewProvider {
    static var previews: some View {
        OldestPhotosView(leftMenuState: .constant(false), rightMenuState: .constant(false))
    }
}
#endif