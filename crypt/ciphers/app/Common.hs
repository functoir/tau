{-# LANGUAGE BlockArguments        #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# OPTIONS -Wall -fwarn-tabs -fno-warn-type-defaults #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

-- | This module implements common functionalities for Text
module Common (
    clean
  , toInt
  , uppercase
  , lowercase
  , toUpper
  , toLower
  , dropLines
  , chr
  , ord
  , split
  , splitT
) where

import Data.Char (chr, ord, toLower, toUpper)
import Data.List (transpose)
import Prelude

-- | Clean up the given string by removing all non-alphabetical characters
clean :: String -> String
clean = filter isalpha

-- | Check if char is puctuation
ispunct :: Char -> Bool
ispunct c = c `elem` "\n!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"

-- | Check if char is space
isspace :: Char -> Bool
isspace c = c `elem` " \t\r\f\v"

-- | Check if char is alphabeticall, i.e. neither punct nor space
isalpha :: Char -> Bool
isalpha c = not (isspace c || ispunct c)

lowercase, uppercase :: String -> String
-- | Convert string to lowercase
lowercase = map toLower

dropLines :: String -> String
dropLines = filter (/= '\n')

-- | convert string to uppercase
uppercase = map toUpper

-- | Read the integer value of a single character.
toInt :: Char -> Int
toInt x = read [x] :: Int

split :: Int -> String -> [String]
split 0 results = [results]
split _ []      = []
split n str     = let (a,b) = splitAt n str in a : split n b

splitT :: Int -> String -> [String]
splitT n str = transpose $ split n str
