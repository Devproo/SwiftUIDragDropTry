//
//  ContentView.swift
//  SwiftUIDragDropTry
//
//  Created by ipeerless on 23/08/2023.
//

import SwiftUI
import Algorithms
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var toDoTasks: [DeveloperTask] = [MockData.taskOne, MockData.taskTwo, MockData.taskThree]
    @State private var inprogressTasks: [DeveloperTask] = []
    @State private var doneTasks:[DeveloperTask] = []
    
    @State private var isToDoTargeted = false
    @State private var isInProgressTargeted = false
    @State private var isDoneTargeted = false
    
    var body: some View {
        HStack {
            KanbanView(title: "To Do", tasks: toDoTasks, isTargeted: isToDoTargeted)
                .dropDestination(for: DeveloperTask.self) { droppedTasks, location in
                    for task in droppedTasks {
                        inprogressTasks.removeAll {$0.id == task.id}
                        doneTasks.removeAll {$0.id == task.id}
                    }
                    
                    let totalTasks =  toDoTasks + droppedTasks
                    toDoTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isToDoTargeted = isTargeted
                }
            
            KanbanView(title: "In Progress", tasks: inprogressTasks, isTargeted: isInProgressTargeted)
                .dropDestination(for: DeveloperTask.self) { droppedTasks, location in
                    for task in droppedTasks {
                        toDoTasks.removeAll {$0.id == task.id}
                        doneTasks.removeAll {$0.id == task.id}
                    }
                    let totalTasks =  inprogressTasks + droppedTasks
                    inprogressTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                    isInProgressTargeted = isTargeted
                }
            
            KanbanView(title: "Done", tasks: doneTasks, isTargeted: isDoneTargeted)
                .dropDestination(for: DeveloperTask.self) {
                    droppedTasks, location in
                    for task in droppedTasks {
                        inprogressTasks.removeAll {$0.id == task.id}
                        inprogressTasks.removeAll {$0.id == task.id}
                    }
                    let totalTasks =  doneTasks + droppedTasks
                   doneTasks = Array(totalTasks.uniqued())
                    return true
                } isTargeted: { isTargeted in
                  isDoneTargeted = isTargeted
                }
                }
                .padding()
        }
    }
    
    #Preview {
        ContentView()
    }
    
    struct KanbanView: View {
        let title: String
        let tasks: [DeveloperTask]
        let isTargeted: Bool
        
        
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.footnote.bold())
                
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(isTargeted ? .teal.opacity(0.15) :  Color(.secondarySystemFill))
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(tasks, id: \.id) { task in
                            Text(task.title)
                                .padding(12)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(8)
                                .shadow(radius: 1, x: 1, y: 1)
                                .draggable(task)
                        }
                        Spacer()
                        
                    }
                    .padding(.vertical)
                }
            }
        }
    }

struct DeveloperTask: Transferable , Codable, Hashable {
    let id: UUID
    let title: String
    let owner: String
    let note: String
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .developerTask)
    }
    
    
}

extension UTType {
    static let developerTask = UTType(exportedAs: "se.iappie")
}

struct MockData {
    static let taskOne = DeveloperTask(id: UUID(), title: "Observalbe Migration", owner: "Adam", note: "placeholder")
    static let taskTwo = DeveloperTask(id: UUID(), title: "Keyframe Animations", owner: "Eve", note: "placeholder")
    static let taskThree = DeveloperTask(id: UUID(), title: "Migrate to Swift Data", owner: "Alex", note: "placeholder")
}
