module Utils where

import System.IO.Unsafe(unsafeDupablePerformIO)

logo :: String
logo = unsafeDupablePerformIO (readFile "logo.txt")