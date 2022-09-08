import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(NablaMessagingClientModule)
final class NablaMessagingClientModule: NSObject {

    private var createConversationCancellable: Cancellable?
    private var sendMessageCancellable: Cancellable?
    private var deleteMessageCancellable: Cancellable?
    private var markConversationAsSeenCancellable: Cancellable?
    private var setIsTypingCancellable: Cancellable?

    @objc(initializeMessagingModule:rejecter:)
    func initializeMessagingModule(resolver: RCTPromiseResolveBlock, rejecter _: RCTPromiseRejectBlock) {
        NablaModules.addModule(NablaMessagingModule())
        resolver(NSNull())
    }

    @objc(createConversation:providerIds:callback:)
    func createConversation(
        title: String?,
        providerIds: [String]?,
        callback: @escaping RCTResponseSenderBlock
    ) {
        createConversationCancellable = NablaMessagingClient.shared.createConversation(
            title: title,
            providerIds: providerIds?.compactMap(UUID.init)
        ) { result in
            switch result {
            case .success(let conversation):
                callback([NSNull(), conversation.id.uuidString])
            case .failure(let error):
                callback([error.dictionaryRepresentation])
            }
        }
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

        sendMessageCancellable = NablaMessagingClient.shared.sendMessage(
            messageInput,
            replyingToMessageWithId: replyToMap?.asMessageId,
            inConversationWithId: conversationId,
            handler: { result in
                switch result {
                case .success:
                    callback([NSNull()])
                case .failure(let error):
                    callback([error.dictionaryRepresentation])
                }
            }
        )
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

        deleteMessageCancellable = NablaMessagingClient.shared.deleteMessage(
            withId: messageId,
            conversationId: conversationId,
            handler: { result in
                switch result {
                case .success:
                    callback([NSNull()])
                case .failure(let error):
                    callback([error.dictionaryRepresentation])
                }
            }
        )
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

        markConversationAsSeenCancellable = NablaMessagingClient.shared.markConversationAsSeen(conversationId, handler: { result in
            switch result {
            case .success:
                callback([NSNull()])
            case .failure(let error):
                callback([error.dictionaryRepresentation])
            }
        })
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

        setIsTypingCancellable = NablaMessagingClient.shared.setIsTyping(
            isTyping,
            inConversationWithId: conversationId,
            handler: { result in
                switch result {
                case .success:
                    callback([NSNull()])
                case .failure(let error):
                    callback([error.dictionaryRepresentation])
                }
            })
    }

    @objc class func requiresMainQueueSetup() -> Bool {
        false
    }
}

