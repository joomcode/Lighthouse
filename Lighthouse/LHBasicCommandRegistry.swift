//
//  LHBasicCommandRegistry.swift
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 06.02.2021.
//

public extension LHBasicCommandRegistry {
    func bind<Command>(_ commandType: Command.Type, to target: LHTarget) where Command: LHCommand {
        __bindCommand(commandType, to: target)
    }

    func bind<Command>(_ commandType: Command.Type, activating node: LHNode) where Command: LHCommand {
        __bindCommand(commandType, to: LHTarget.withActiveNode(node))
    }

    func bind<Command>(_ commandType: Command.Type, deactivating node: LHNode) where Command: LHCommand {
        __bindCommand(commandType, to: LHTarget.withInactiveNode(node))
    }

    func bind<Command>(_ commandType: Command.Type, activating node: LHNode, origin: LHRouteHintOrigin) where Command: LHCommand {
        let hint = LHRouteHint(nodes: nil, origin: origin, bidirectional: false)
        return __bindCommand(commandType, to: LHTarget.withActiveNode(node, routeHint: hint))
    }

    func bind<Command>(_ commandType: Command.Type, deactivating node: LHNode, origin: LHRouteHintOrigin) where Command: LHCommand {
        let hint = LHRouteHint(nodes: nil, origin: origin, bidirectional: false)
        return __bindCommand(commandType, to: LHTarget.withInactiveNode(node, routeHint: hint))
    }

    func bind<Command>(_ commandType: Command.Type, to targetFactory: @escaping (Command) -> LHTarget) where Command: LHCommand {
        __bindCommand(commandType, to: { command in
            guard let command = command as? Command else { return nil }

            return targetFactory(command)
        })
    }
}
