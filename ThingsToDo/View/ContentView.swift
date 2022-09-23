//
//  ContentView.swift
//  ThingsToDo
//
//  Created by Kosei Ban on 2022-09-16.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - Property
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var task: String = ""
    @State private var showNewTaskView: Bool = false
    
    // Fetching Data
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //MARK: - Function
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
              //MARK: - MainView
                
                VStack {
                    //MARK: - Header
                    
                    HStack(spacing: 10) {
                        // Title
                        Text("To do")
                          .font(.system(.largeTitle, design: .rounded))
                          .fontWeight(.heavy)
                          .padding(.leading, 4)
                        
                        Spacer()
                        // Edit Button
                        
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                              Capsule().stroke(Color.white, lineWidth: 2)
                            )
                        
                        // Light : Dark Button
                        Button  {
                            // TOGGLE APPEARANCE
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkMode ? "moon.stars.fill" :  "sun.max.fill")
                              .resizable()
                              .frame(width: 24, height: 24)
                              .font(.system(.title, design: .rounded))
                        }//: Light : Dark Button
                    }//: HStack
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    //MARK: - NewTaskButton
                    Button  {
                        showNewTaskView = true
                        playSound(sound: "sound-ding", type: "mp3")
                        feedback.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "plus.circle")
                          .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                          .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                      LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                        .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)

                    // Task List
                    List {
                        ForEach(items) { item in
                            
                            VStack(alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                        }
                        .onDelete(perform: deleteItems)
                    }//: List
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                }//: Vstack
                
                //MARK: - NewTaskView
                
                if showNewTaskView {
                   
                    BlankView(backgroundColor: Color.black, backgroundOpacity: 0.6)
                        .onTapGesture {
                            withAnimation() {
                                showNewTaskView = false
                            }//: WithAnimation
                        }//: OntapGesture
                    
                    NewTaskView(isShowing: $showNewTaskView)
                    
                }//: If( showNewTaskView)
            }//: ZStack
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarHidden(true)
            .background(
            BackgroundImageView()
            )
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
        }//: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }//: Body
}

//MARK: -  PreView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
