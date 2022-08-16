import Foundation
import NablaCore
import NablaMessagingCore
import nabla_react_native_core

@objc(NablaMessagingClientModule)
final class NablaMessagingClientModule: NSObject {

    private var createConversationCancellable: Cancellable?
    private var sendMessageCancellable: Cancellable?

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
        input: Dictionary<String, Any>,
        conversationIdMap: Dictionary<String, Any>,
        replyToMap: Dictionary<String, Any>?,
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

    @objc class func requiresMainQueueSetup() -> Bool {
        false
    }
}

