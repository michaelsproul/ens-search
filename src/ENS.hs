module ENS
    ( sha3,
      getAllowedTime,
      getCurrentTime,
      digestToInteger,
      permute,
      allPermute
    ) where

import Data.Time.Clock.POSIX (posixSecondsToUTCTime, getCurrentTime)
import Data.Time.Clock (UTCTime)
import Data.ByteString (ByteString)
import Data.ByteArray (unpack)
import Data.Bits (shiftL, shiftR)
import Crypto.Hash (hash, Digest)
import Crypto.Hash.Algorithms (Keccak_256)

-- | Keccak-256 hash function, equivalent to Ethereum's web3.sha3
sha3 :: ByteString -> Digest Keccak_256
sha3 = hash

-- | Timestamp in seconds for when the registry was started.
-- | Sourced from: https://etherscan.io/address/0x6090a6e47849629b7245dfa1ca21d94cd15878ef#code
registryStarted :: Integer
registryStarted = 0x590b09b0

-- | Length of the delayed launch in seconds (8 weeks).
launchLength :: Integer
launchLength = 8 * 7 * 24 * 60 * 60

-- | Compute the time that a given name is allowed at.
-- | This mirrors getAllowedTime from the registrar contract.
getAllowedTime :: ByteString -> UTCTime
getAllowedTime name = posixSecondsToUTCTime $ fromInteger ts
    where ts = registryStarted + shiftR (launchLength * shiftR nameInt 128) 128
          nameInt = digestToInteger (sha3 name)

-- | Treat the bytes of a digest as a little-endian Integer.
digestToInteger :: Digest a -> Integer
digestToInteger digest = sum $ map convert (enumerate bytes)
    where convert (i, v) = shiftL (toInteger v) (8 * (len - 1 - i))
          len = length bytes
          bytes = unpack digest

-- | Number the elements of a list with their index.
enumerate :: [a] -> [(Int, a)]
enumerate = zip [0..]

-- | All permutations of size up-to n.
allPermute :: Int -> [a] -> [[a]]
allPermute n xs = concatMap (\i -> permute i xs) [0..n]

-- | All permutations of size n.
permute :: Int -> [a] -> [[a]]
permute n = permute' n []

permute' :: Int -> [a] -> [a] -> [[a]]
permute' 0 _ _ = [[]]
permute' _ _ [] = []
permute' n ls (r:rs) =
    -- Take it...
    map (r:) (permute' (n - 1) [] (ls ++ rs)) ++
    -- Or leave it...
    permute' n (ls ++ [r]) rs
