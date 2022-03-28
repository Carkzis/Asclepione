//
//  EntityPublisher.swift
//  Asclepione
//
//  Created by Marc Jowett on 18/03/2022.
//

import Foundation
import Combine
import CoreData

class EntityPublisher<Entity>: NSObject, NSFetchedResultsControllerDelegate, Publisher where Entity: NSManagedObject {

    typealias Output = [Entity]
    typealias Failure = Error

    private let fetchRequest: NSFetchRequest<Entity>!
    private let subject: CurrentValueSubject<[Entity], Failure>!
    private let managedObjectContext: NSManagedObjectContext!
    private var resultController: NSFetchedResultsController<NSManagedObject>?
    private var totalSubscriptions = 0
    
    init(fetchRequest: NSFetchRequest<Entity>) {
        self.fetchRequest = fetchRequest
        self.subject = CurrentValueSubject([])
        self.managedObjectContext = PersistenceController.shared.container.viewContext
        super.init()
    }

    func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, [Entity] == S.Input {
        // Synchronise our subscriptions to ensure accuracy.
        objc_sync_enter(self)
        totalSubscriptions += 1
        let firstSubscriber = totalSubscriptions == 1
        objc_sync_exit(self)
        
        if firstSubscriber {
            createController()
        }
        
        EntitySubscription(fetchPublisher: self, subscriber: AnySubscriber(subscriber))
    }
    
    /*
     If we receive an initial subscriber, we create an NSFetchedResultsController, which sends results to
     the subscriber. Future subscribers use the same controller to get their results.
     */
    func createController() {
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        managedObjectContext.perform {
            do {
                try controller.performFetch()
                let result = controller.fetchedObjects ?? []
                self.subject.send(result)
            } catch {
                self.subject.send(completion: .failure(error))
            }
        }
        resultController = controller as? NSFetchedResultsController<NSManagedObject>
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let result = resultController?.fetchedObjects as? [Entity] ?? []
        subject.send(result)
    }
    
    private func dropSubscription() {
        // Synchronise our subscriptions to ensure accuracy.
        objc_sync_enter(self)
        totalSubscriptions -= 1
        let stopObserving = totalSubscriptions == 0
        objc_sync_exit(self)
        
        if stopObserving {
            resultController?.delegate = nil
            resultController = nil
        }
    }
    
    private class EntitySubscription: Subscription {
        private var fetchPublisher: EntityPublisher?
        private var cancellable: AnyCancellable?
        
        @discardableResult
        init(fetchPublisher: EntityPublisher, subscriber: AnySubscriber<Output, Failure>) {
            self.fetchPublisher = fetchPublisher
            // This tells the subscriber it has subscribed to the publisher and may request items.
            subscriber.receive(subscription: self)
            
            
            cancellable = fetchPublisher.subject.sink(receiveCompletion: { completion in
                // Tell sthe subscriber the publishing has finished.
                subscriber.receive(completion: completion)
            }, receiveValue: { value in
                // Give the subscriber the value received.
                _ = subscriber.receive(value)
            })
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            cancellable?.cancel()
            cancellable = nil
            fetchPublisher?.dropSubscription()
            fetchPublisher = nil
        }
                
    }
}
