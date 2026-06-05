/* TODO:
 - enum "Action" ✅
 - Method to generate EnemyAction ❌
 - Queue data structure to hold actions ❌
 - Method to execute actions from the queue ❌
 - AsyncAwait for simulation of delays ❌
 - Visual representation of different actions on the view and with it's execution
 
 Try to simulate an antire cycle of enemy action queue with sumulated effects and delay
 also try flask wasActionStarted and wasActionEnded
 */

import SwiftUI

// A simple model to represent an actual action

struct Action {
	
	var name: String
	var actionType: ActionType
	var timeToCast: Double
}

// Any type of character actions in the battle

enum ActionType: String {
	
	case fastAttack
	case slowAttack
	case heal
	case block
	case ultimate
}

// We need a queue to fill with actions

struct ActionQueue<Action> {
	
	var queue: [Action] = []
	
	var count: Int {
		queue.count
	}
	
	mutating func addAction(action: Action) {
		queue.append(action)
	}
	
	mutating func executeAction() -> Action? {
		
		guard !queue.isEmpty else {
			// pass turn to hero
			return nil
		}
		return queue.removeFirst()
	}
}

struct ContentView: View {
	
	@State var actionQueue = ActionQueue<Action>()
	
    var body: some View {
		
		VStack {
			Text("Action Queue. (\(actionQueue.count))")
			
			Button("Add Action") {
				
				var actionType: ActionType
				
				let roll = Int.random(in: 1...5)
				
				switch roll {
				case 1: actionType = ActionType.fastAttack
				case 2: actionType = ActionType.slowAttack
				case 3: actionType = ActionType.heal
				case 4: actionType = ActionType.block
				case 5: actionType = ActionType.ultimate
				default:
					actionType = ActionType.fastAttack
				}
				
				let action = Action(name: actionType.rawValue, actionType: actionType, timeToCast: 2.0)
				
				actionQueue.addAction(action: action)
			}
			
			Button("Execute Action") {
				guard let action = actionQueue.executeAction() else { return }
				print(action.name)
			}
		}
    }
}
