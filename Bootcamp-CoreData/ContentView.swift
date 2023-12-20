//
//  ContentView.swift
//  Bootcamp-CoreData
//
//  Created by lorenliang on 2023/12/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Fruit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Fruit.name, ascending: false)]
    )
    var fruits: FetchedResults<Fruit>
    
    @State var textFieldText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Add Fruit here...", text: $textFieldText)
                    .padding(.leading)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.horizontal)
                
                Button(action: {
                    addItem()
                }, label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding(.horizontal)
                })
                
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Fruits")
        }
    }

    private func addItem() {
        // not work on canvas
        withAnimation {
            print("addItem() invoke...")
            
            let newFruit = Fruit(context: viewContext)
            newFruit.name = textFieldText

            saveItems()
            
            textFieldText = ""
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let fruit = fruits[index]
            viewContext.delete(fruit)

            saveItems()
        }
    }
    
    private func updateItem(fruit: Fruit) {
        withAnimation {
            let currentName = fruit.name ?? ""
            let newName = currentName + "!"
            
            fruit.name = newName
            
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
