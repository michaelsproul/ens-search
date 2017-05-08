module Main where

import ENS
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BSC
import Data.ByteString (ByteString)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import Control.Monad (forM_)
import GHC.Exts (sortWith)

-- | Get two command-line args: filename and permutation limit.
-- TODO: make permutation limit optional and add an optional print limit.
loadArgs :: IO (String, Int)
loadArgs = do
    args <- getArgs
    if length args /= 2 then do
        putStrLn "usage: ens-search <word file> <permutation limit>"
        exitFailure
    else
        pure (args !! 0, read $ args !! 1)

loadNames :: IO ([ByteString], Int)
loadNames = do
    (fileName, permLimit) <- loadArgs
    fileContents <- BS.readFile fileName
    pure (BSC.lines fileContents, permLimit)

main :: IO ()
main = do
    (names, limit) <- loadNames
    let permutations = allPermute limit names
    let validNames = filter ((>=7) . BS.length) (map BS.concat permutations)
    let namesAndTimes = sortWith snd $ map (\name -> (name, getAllowedTime name)) validNames
    forM_ (take 20 $ namesAndTimes) $ \(name, time) ->
        let domain = BSC.unpack name ++ ".eth" in
        putStrLn $ domain ++ " available at " ++ (show time)
