{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# OPTIONS -Wall -fwarn-tabs -fno-warn-type-defaults #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module Ciphers.ShiftCipher (
    encrypt
  , decrypt
  , bruteforceAttack
  , bruteforce
  , shiftChar
) where

import Ciphers.Common        (clean, lowercase, uppercase, charToInt)
import Data.Char     (chr, ord)
import Data.Foldable (for_)
import Data.List     (elemIndex)
import Prelude

-- | Encrypt a message, per the given key.
encrypt :: Int -> String -> String
encrypt key str = do
  let rawText = lines str
  let cleanedText = map (uppercase . clean) rawText
  let ciphertext = map (shift key) cleanedText
  unlines ciphertext

-- | Decrypt a message, per the given key.
decrypt :: Int -> String -> String
decrypt key ciphertext = do
  let rawText = lines ciphertext
  let cleanedText = map (uppercase . clean) rawText
  let plaintext = map (shift (-key)) cleanedText
  lowercase $ unlines plaintext

-- | Shift a string, the easy way -- add and mod.
-- | We assume char is uppercase.
shift :: Int -> String -> String
shift _ []     = []
shift n (c:cs) = shiftChar n c : shift n cs
  where
    shiftChar n c =
      let pos = ord c - ord 'A'
      in chr ((pos + n) `mod` 26 + ord 'A')


-- | Shift a char by a given amount.
--
-- Designed for the Vigenere Cipher, it takes two chars (A=0, B=1, etc.)
--
-- Example:
--
-- >>> (char, step) = ('A' 'C')
-- >>> shiftChar step char == 'C'
shiftChar :: Char -> Char -> Char
shiftChar step char =
  let pos = charToInt char
      step' = charToInt step
  in chr $ (pos + step') `mod` 26 + ord 'A'

-- | Run a brute-force attack: try every possible shift in the English alphabet.
bruteforceAttack :: String -> [String]
bruteforceAttack str = checkAll 0 str []
  where
    -- | Check all possible shifts, up to 26 then stop.
    checkAll :: Int -> String -> [String] -> [String]
    checkAll 26 _ arr = arr
    checkAll n text results =
      checkAll (n+1) text (results ++ [decrypt n text])

-- | Run a brute-force attack: try every possible shift in the English alphabet.
--
-- Print results instead of returning them to sender.
bruteforce :: [Char] -> IO ()
bruteforce str = do
  let results = bruteforceAttack str
  for_ results $ \result -> do
    putStrLn $ "\t" ++ show (fromJust (elemIndex result results)) ++ ": " ++ result

fromJust :: Maybe Int -> Int
fromJust (Just x) = x
fromJust Nothing  = 0
