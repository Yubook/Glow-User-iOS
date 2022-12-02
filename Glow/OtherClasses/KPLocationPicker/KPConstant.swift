

import Foundation

let googleKey = "AIzaSyDlcNgnMyVQGI6pNOsv8vUA_madpVrLeMg"

/// If google key is empty than location fetch via goecode.
var isGooleKeyFound : Bool = {
    return !googleKey.isEmpty
}()
