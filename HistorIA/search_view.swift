//
//  search_view.swift
//  HistorIA
//
//  Created by Alumno on 17/03/24.
//

import SwiftUI

struct search_view: View {
    
    @State private var searchText: String = ""
      @State private var searchResults: [String] = []
      @State private var navigateToTopicView: Bool = false

      var body: some View {
          NavigationView {
              VStack {
                    TextField("Buscar", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                  NavigationLink("Ir a Topic", destination: TopicView(query: searchText))

                }
          }
      }
  }
