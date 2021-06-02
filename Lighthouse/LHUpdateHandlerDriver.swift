//
//  LHUpdateHandlerDriver.swift
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 06.02.2021.
//

public extension LHUpdateHandlerDriver {
    typealias DataInitClosure<Command> = (Command, LHUpdateBus) -> Any?
    typealias DataUpdateClosure<Command> = (Any, Command, LHUpdateBus) -> Any

    static func driver<Command>(
        for commandType: Command.Type,
        with dataInitClosure: @escaping DataInitClosure<Command>
    ) -> LHUpdateHandlerDriver where Command: LHCommand {
        let driver = LHUpdateHandlerDriver()

        driver.bind(commandType) { command, updateBus in
            guard let command = command as? Command else {
                assertionFailure()
                return nil
            }

            return dataInitClosure(command, updateBus)
        }

        return driver
    }

    func bind<Command>(_ commandType: Command.Type, to dataInitClosure: @escaping DataInitClosure<Command>) where Command: LHCommand {
        __bindCommand(commandType, toDataInitBlock: { command, updateBus in
            guard let command = command as? Command else {
                assertionFailure()
                return nil
            }

            return dataInitClosure(command, updateBus)
        })
    }

    func bindUpdate<Command>(for commandType: Command.Type, to dataUpdateClosure: @escaping DataUpdateClosure<Command>) where Command: LHCommand {
        __bindCommand(commandType, toDataUpdate: { data, command, updateBus in
            guard let command = command as? Command else {
                preconditionFailure()
            }

            return dataUpdateClosure(data, command, updateBus)
        })
    }
}
