/* Algorithm of execution:
 
 1. Pass turn to enemy
 2. Generate enemy actions (accordingly to energy capacity)
 3. Add actions to the queue
 4. Check if queue is not empty
 5. Grab first action from the queue
 6. Set flag actionInProgress to true
 7. Execute action
 8. Set flag actionInProgress to false
 9. Go back to step 4 until it empty
 */

import SwiftUI

// MARK: Action struct

/// A simple model to represent an actual action
struct Action {
	
	var name: String
	var actionType: ActionType
	var timeToCast: Double
	
	init(name: String,
		 actionType: ActionType,
		 timeToCast: Double
	) {
		self.name = name
		self.actionType = actionType
		self.timeToCast = timeToCast
	}
}

// MARK: ActionType enum

/// Any type of character actions in the battle
enum ActionType: String {
	
	case fastAttack
	case slowAttack
	case heal
	case block
	case ultimate
}

// MARK: ActionQueue struct

/// We need a queue to fill with actions
class ActionQueue {
	
	var queue: [Action] = []
	
	var isEmpty: Bool {
		queue.isEmpty
	}
	
	var actionInProgress = false
	
	var count: Int {
		queue.count
	}
	
	/// Method runs until queue will be empty
	/// You do not need guard in execute/extract action because if it's empty it won't move further
	func executeActions() {
		
		print("Start Running the queue")
		
		while queue.isEmpty != true {
			
			print("Found an action")
			
			if actionInProgress != true {
				
				let action = extractAction()
				print("Passed action for execution")
				executeSingleAction(action)
			}
		}
	}
	
	func addAction(action: Action) {
		queue.append(action)
	}
	
	func extractAction() -> Action {
		queue.removeFirst()
	}
	
	func executeSingleAction(_ action: Action) {
		
		print("Execution started")
		actionInProgress = true
		print("execution continue")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + action.timeToCast) {
			self.actionInProgress = false
			print("action has been executed after \(action.timeToCast) seconds")
		}
	}
}

// MARK: Content View

struct ContentView: View {
	
	@State var actionQueue = ActionQueue()
	
	var body: some View {
		
		VStack {
			Text("Action Queue. (\(actionQueue.count))")
			
			Button("Add Action") {
				print("ARE YOU HERE YOU FUCKING MORON?")
				
				var actionType = ActionType.fastAttack
				var timeToCast = 0.0
				
				let roll = Int.random(in: 1...5)
				
				switch roll {
					
				case 1:
					actionType = ActionType.fastAttack
					timeToCast = 1.0
				case 2:
					actionType = ActionType.slowAttack
					timeToCast = 2.0
				case 3:
					actionType = ActionType.heal
					timeToCast = 1.0
				case 4:
					actionType = ActionType.block
					timeToCast = 1.0
				case 5:
					actionType = ActionType.ultimate
					timeToCast = 3.0
				default:
					actionType = ActionType.fastAttack
					timeToCast = 1.0
				}
				
				let action = Action(name: actionType.rawValue, actionType: actionType, timeToCast: timeToCast)
				
				actionQueue.addAction(action: action)
				print("\(action) has been added")
			}
			
			Button("Execute Actions") {
				actionQueue.executeActions()
			}
		}
	}
}
