import Combine
import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(NablaMessagingClientModule)
final class NablaMessagingClientModule: NSObject {

    @objc(initializeMessagingModule:rejecter:)
    func initializeMessagingModule(resolver: RCTPromiseResolveBlock, rejecter _: RCTPromiseRejectBlock) {
        NablaModules.addModule(NablaMessagingModule())
        resolver(NSNull())
    }

    @objc(createConversation:providerIds:initialMessage:callback:)
    func createConversation(
        title: String?,
        providerIds: [String]?,
        initialMessageInput: [String: Any]?,
        callback: @escaping RCTResponseSenderBlock
    ) {
        let initialMessage: MessageInput?
        if let initialMessageInput = initialMessageInput {
            guard let messageInput = initialMessageInput.messageInput else {
                callback([InternalError.createDictionaryRepresentation(message: "Unable to parse initial message input")])
                return
            }
            initialMessage = messageInput
        } else {
            initialMessage = nil
        }

        Task {
            do {
                let conversation = try await NablaMessagingClient.shared.createConversation(
                    title: title,
                    providerIds: providerIds?.compactMap(UUID.init),
                    initialMessage: initialMessage
                )
                callback([NSNull(), conversation.id.dictionaryRepresentation])
            } catch {
                callback([error.dictionaryRepresentation])
            }
        }
    }

    @objc(createDraftConversation:providerIds:callback:)
    func createDraftConversation(
        title: String?,
        providerIds: [String]?,
        callback: @escaping RCTResponseSenderBlock
    ) {
        let conversation = NablaMessagingClient.shared.createDraftConversation(
            title: title,
            providerIds: providerIds?.compactMap(UUID.init)
        )
        callback([NSNull(), conversation.id.dictionaryRepresentation])
    }

    @objc(sendMessage:conversationId:replyTo:callback:)
    func sendMessage(
        input: [String: Any],
        conversationIdMap: [String: Any],
        replyToMap: [String: Any]?,
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let messageInput = input.messageInput else {
            callback([InternalError.createDictionaryRepresentation(message: "Unable to parse message input")])
            return
        }

        guard let conversationId = conversationIdMap.asConversationId else {
            callback([InternalError.createDictionaryRepresentation(message: "Unable to parse conversationId")])
            return
        }

        Task {
            do {
                try await NablaMessagingClient.shared.sendMessage(
                    messageInput,
                    replyingToMessageWithId: replyToMap?.asMessageId,
                    inConversationWithId: conversationId
                )
                callback([NSNull()])
            } catch {
                callback([error.dictionaryRepresentation])
            }
        }
    }

    @objc(retrySendingMessage:conversationId:callback:)
    func retrySendingMessage(
        messageIdMap: [String: Any],
        conversationIdMap: [String: Any],
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let conversationId = conversationIdMap.asConversationId else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Bad conversationId `\(conversationIdMap)`")
            ])
            return
        }

        guard let messageId = messageIdMap.asMessageId else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Bad messageId `\(messageIdMap)`")
            ])
            return
        }

        Task {
            do {
                try await NablaMessagingClient.shared.retrySending(
                    itemWithId: messageId,
                    inConversationWithId: conversationId
                )
                callback([NSNull()])
            } catch {
                callback([error.dictionaryRepresentation])
            }
        }
    }

    @objc(deleteMessage:conversationId:callback:)
    func deleteMessage(
        messageIdMap: [String: Any],
        conversationIdMap: [String: Any],
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let conversationId = conversationIdMap.asConversationId else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Bad conversationId `\(conversationIdMap)`")
            ])
            return
        }

        guard let messageId = messageIdMap.asMessageId else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Bad messageId `\(messageIdMap)`")
            ])
            return
        }

        Task {
            do {
                try await NablaMessagingClient.shared.deleteMessage(
                    withId: messageId,
                    conversationId: conversationId
                )
                callback([NSNull()])
            } catch {
                callback([error.dictionaryRepresentation])
            }
        }
    }

    @objc(markConversationAsSeen:callback:)
    func markConversationAsSeen(
        conversationIdMap: [String: Any],
        callback: @escaping RCTResponseSenderBlock
    ) {

        guard let conversationId = conversationIdMap.asConversationId else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Bad conversationId `\(conversationIdMap)`")
            ])
            return
        }
        Task {
            do {
                try await NablaMessagingClient.shared.markConversationAsSeen(conversationId)
                callback([NSNull()])
            } catch {
                callback([error.dictionaryRepresentation])
            }
        }
    }

    @objc(setIsTyping:conversationId:callback:)
    func setIsTyping(
        _ isTyping: Bool,
        conversationIdMap: [String: Any],
        callback: @escaping RCTResponseSenderBlock
    ) {
        guard let conversationId = conversationIdMap.asConversationId else {
            callback([
                InternalError.createDictionaryRepresentation(message: "Bad conversationId `\(conversationIdMap)`")
            ])
            return
        }

        Task {
            do {
                try await NablaMessagingClient.shared.setIsTyping(
                    isTyping,
                    inConversationWithId: conversationId
                )
                callback([NSNull()])
            } catch {
                callback([error.dictionaryRepresentation])
            }
        }
    }

    @objc class func requiresMainQueueSetup() -> Bool {
        false
    }
}

