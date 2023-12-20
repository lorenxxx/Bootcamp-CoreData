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

    var body: some View {
        NavigationView {
            List {
                ForEach(fruits) { fruit in
                    Text(fruit.name ?? "")
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .navigationTitle("Fruits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        // not work
        withAnimation {
            print("addItem() invoke...")
            
            let newFruit = Fruit(context: viewContext)
            newFruit.name = "Orange"

            saveItems()
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
