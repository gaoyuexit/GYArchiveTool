import Foundation
import CommandLineKit
import Rainbow
import GYArchiveKit


let cli = CommandLineKit.CommandLine()


// 工程路径, 默认为当前文件夹
let projectOption   = StringOption(shortFlag: "p",
                                    longFlag: "project",
                                 helpMessage: "Path to the project.")

let logOption       = StringOption(shortFlag: "l",
                                    longFlag: "log",
                                    helpMessage: "ChangeLog for fir")

let versionOption   = StringOption(shortFlag: "v",
                                 longFlag: "version",
                                 helpMessage: "Is Auto Change Version")

let uploadOption    = StringOption(shortFlag: "u",
                                 longFlag: "upload",
                                 helpMessage: "Upload to fir")

let commitOption    = StringOption(shortFlag: "c",
                                 longFlag: "commit",
                                 helpMessage: "Auto Git Commit to log this Archive")

let infoPathOption  = StringOption(shortFlag: "i",
                                   longFlag: "info",
                                   helpMessage: "The path of Info.plist")


let help            = BoolOption(shortFlag: "h",
                                 longFlag: "help",
                                 helpMessage: "Prints a help message.")


cli.addOptions(projectOption, logOption, versionOption, uploadOption, commitOption, help)

// Rainbow:  highlight show
cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.blue
    default:
        str = s
    }
    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if help.value {
    cli.printUsage()
    exit(EX_OK)
}

print("///////////////////////////////////////////////")
print("//////                                   //////")
print("//////               Hello               //////")
print("//////                                   //////")
print("///////////////////////////////////////////////")


do {
    let tool = try Archive(projectPath: projectOption.value, log: logOption.value, version: versionOption.value, upload: uploadOption.value, commit: commitOption.value, infoPath: infoPathOption.value)
}catch {
    
}

























