import Foundation
import CommandLineKit
import Rainbow
import ArchiveKit
import PathKit

let cli = CommandLineKit.CommandLine()


// 工程路径, 默认为当前文件夹
let rootPathOption   = StringOption(shortFlag: "r",
                                    longFlag: "root",
                                 helpMessage: "Path to the project dir")

let logOption       = StringOption(shortFlag: "l",
                                    longFlag: "log",
                                    helpMessage: "ChangeLog for fir")

let versionOption   = BoolOption(shortFlag: "no-v",
                                 longFlag: "no-version",
                                 helpMessage: "Not Auto Change Version")

let uploadOption    = BoolOption(shortFlag: "no-u",
                                 longFlag: "no-upload",
                                 helpMessage: "Not Upload to fir")

let commitOption    = BoolOption(shortFlag: "no-c",
                                 longFlag: "no-commit",
                                 helpMessage: "Not Git Commit to log this Archive")

let infoPathOption  = StringOption(shortFlag: "i",
                                   longFlag: "info",
                                   helpMessage: "The path of Info.plist")


let help            = BoolOption(shortFlag: "h",
                                 longFlag: "help",
                                 helpMessage: "Prints a help message.")


cli.addOptions(rootPathOption, logOption, versionOption, uploadOption, commitOption, infoPathOption, help)

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

print("_________".lightGreen)
print("/         /.".lightGreen)
print(".----------------       /_________/ |".lightGreen)
print("/              / |      |         | |".lightGreen)
print("/+============+\\ |      | |====|  | |".lightGreen)
print("||C:\\>        || |      |         | |".lightGreen)
print("|| welcome    || |      | |====|  | |".lightGreen)
print("|| use        || |      |   ___   | |".lightGreen)
print("|| archive    || |      |  |250|  | |".lightGreen)
print("|| tool       ||/@@@    |   ---   | |".lightGreen)
print("\\+============+/    @   |_________|./.".lightGreen)
print("@          ..  ....'".lightGreen)
print("..................@     __.'.'  ''".lightGreen)
print("/oooooooooooooooo//     ///".lightGreen)
print("/................//     /_/".lightGreen)
print("------------------".lightGreen)

let fileProcess: FileProcess

do {
    fileProcess = try FileProcess(rootPathString: rootPathOption.value ?? Path.current.string, infoPath: infoPathOption.value)
}catch {
    guard let e = error as? FileError else {
        exit(EX_USAGE)
    }
    switch e {
    case .noFindInfoPlist: print("------------------ no find info plist ------------------".error)
    case .noFindProject: print("------------------ no find project ------------------".error)
    }
    exit(EX_USAGE)
}


do {
    let tool = try Archive(fileProcess: fileProcess, log: logOption.value, version: versionOption.value, upload: uploadOption.value, commit: commitOption.value)
    tool.execute()
}catch {
    
}



























