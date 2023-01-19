//
//  InstructionsCell+Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 22/11/2022.
//

import Foundation

extension InstructionsCell {
    struct Model {
        let title: String
        let firstAccessoryText: String?
        let firstAccessoryIcon: Image?
        let secondAccessoryIcon: Image
        let firstInstructionText: String?
        let secondInstructionText: String
        let hasASingleInstruction: Bool
        let hasFirstAccessoryText: Bool

        init(
            title: String,
            firstAccessoryText: String? = nil,
            firstAccessoryIcon: Image? = nil,
            secondAccessoryIcon: Image,
            firstInstructionText: String? = nil,
            secondInstructionText: String,
            hasASingleInstruction: Bool,
            hasFirstAccessoryText: Bool
        ) {
            self.title = title
            self.firstAccessoryText = firstAccessoryText
            self.firstAccessoryIcon = firstAccessoryIcon
            self.secondAccessoryIcon = secondAccessoryIcon
            self.firstInstructionText = firstInstructionText
            self.secondInstructionText = secondInstructionText
            self.hasASingleInstruction = hasASingleInstruction
            self.hasFirstAccessoryText = hasFirstAccessoryText
        }
    }
}
