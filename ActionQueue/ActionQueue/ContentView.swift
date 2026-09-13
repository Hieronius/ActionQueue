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
 
 // MARK: Try to implement this game pause feature in consol
 
 // Inside your GameState class
 @Published var isGamePaused = false

 // A helper function (can be placed in a utility file or extension)
 func pauseableSleep(seconds: Double) async throws {
	 // this small chunk faster than a single frame so user will see an actual pause
	 let chunkSize = 0.05 // 50ms - small enough to feel instant on resume
	 // this property we use to track how much time we slept
	 var elapsed: Double = 0.0
	 
	 while elapsed < seconds {
		 // 1. Check if we are paused - if so, wait indefinitely until unpaused
		 while gameState.isGamePaused {
			 // Sleep for 100ms while paused to keep the thread responsive
			 try await Task.sleep(for: .milliseconds(100))
			 // Check if the task was externally cancelled (e.g., user quit the battle)
			 try Task.checkCancellation()
		 }
		 
		 // 2. Sleep for the next chunk
		 let remaining = seconds - elapsed
		 let sleepTime = min(chunkSize, remaining)
		 try await Task.sleep(for: .seconds(sleepTime))
		 elapsed += sleepTime
		 
		 // 3. Allow cancellation
		 try Task.checkCancellation()
	 }
 }
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
	func executeActions() async {
		
		print("Start Running the queue")
		
		while queue.isEmpty != true {
			
			print("Found an action")
			
			if actionInProgress != true {
				
				let action = extractAction()
				print("Passed action for execution")
				await executeSingleAction(action)
			}
		}
	}
	
	func addAction(action: Action) {
		queue.append(action)
	}
	
	func extractAction() -> Action {
		queue.removeFirst()
	}
	
	func executeSingleAction(_ action: Action) async {
		
		guard !actionInProgress else { return }
		print("Execution started. actionInProgress - \(actionInProgress)")
		actionInProgress = true
		
		do {
			try await Task.sleep(nanoseconds: 1_000_000_000)
			print("In the middle")
		} catch {
			print("Has been canceled")
		}
		actionInProgress = false
		print("Execution ends. actionInProgress - \(actionInProgress)")
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
