//
//  MailView.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/11.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var data: MailData
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([data.recipient])
        vc.setSubject(data.subject)
        vc.setMessageBody(data.message, isHTML: false)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(dismiss: dismiss)
    }
    
    static var canBePresented: Bool {
        MFMailComposeViewController.canSendMail()
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var dismiss: DismissAction
        
        init(dismiss: DismissAction) {
            self.dismiss = dismiss
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                print("‼️‼️‼️ \(error.localizedDescription)")
            } else {
                print("‼️‼️‼️ \(result)")
                dismiss()
            }
        }
    }
    
    struct MailData {
        let subject: String
        let recipient: String
        let message: String
    }
}
