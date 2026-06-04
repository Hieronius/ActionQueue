/* TODO:
 - enum "EnemyAction" ❌
 - Method to generate EnemyAction ❌
 - Queue data structure to hold actions ❌
 - Method to execute actions from the queue ❌
 - AsyncAwait for simulation of delays ❌
 - Visual representation of different actions on the view and with it's execution
 */

import SwiftUI

// Any type of character actions in the battle

enum Action: String {
	
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
				
				var action: Action
				
				let roll = Int.random(in: 1...5)
				
				switch roll {
				case 1: action = Action.fastAttack
				case 2: action = Action.slowAttack
				case 3: action = Action.heal
				case 4: action = Action.block
				case 5: action = Action.ultimate
				default:
					action = Action.fastAttack
				}
				
				actionQueue.addAction(action: action)
			}
			
			Button("Execute Action") {
				guard let action = actionQueue.executeAction() else { return }
				print(action.rawValue)
			}
		}
    }
}
