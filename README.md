# Get Break Type

Pascal function to detect the type of line break in a file. It will return a "TBreakType", which can be:

- btBinary: Probably a binary file
- btWindows: CR/LF detected
- btMacintosh: CR detected
- btUnix: LF detected
- btUnknown: Unknown line break given the MaxDataToRead limit