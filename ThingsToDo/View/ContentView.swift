//
//  ContentView.swift
//  ThingsToDo
//
//  Created by Kosei Ban on 2022-09-16.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    init() {
            UICollectionView.appearance().backgroundColor = .clear
    }
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
                                Capsule().stroke(isDarkMode ? Color.white : Color.black, lineWidth: 2)
                            )
                        
                        // Light : Dark Button
                        Button  {
                            // TOGGLE APPEARANCE
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.stars.fill" )
                              .resizable()
                              .frame(width: 24, height: 24)
                              .font(.system(.title, design: .rounded))
                        }//: Light : Dark Button
                    }//: HStack
                    .padding()
                    .foregroundColor( isDarkMode ? .white : .black)
                    
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
                    .foregroundColor(isDarkMode ? .white : .black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                      LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                        .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)

                    //MARK: - TaskList
                    if #available(iOS 16.0, *) {
                        List {
                            ForEach(items) { item in
                                ListRowItemView( item: item)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                            }//: ForEach
                            .onDelete(perform: deleteItems)
                        }//: List
                        .padding()
                        .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.3), radius: 12)
                    } else {
                        // Fallback on earlier versions
                    }
                }//: Vstack
                .blur(radius: showNewTaskView ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))
                //MARK: - NewTaskView
                
                if showNewTaskView {
                    BlankView(backgroundColor: isDarkMode ? Color.black : Color.gray, backgroundOpacity: isDarkMode ?  0.3 : 0.5)
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
                .blur(radius: showNewTaskView ? 8.0 : 0, opaque: false)
                
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
