{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty

import Config.Conf
import Config.Logger

main :: IO ()
main = do
  config <- load configFiles
  myConf <- myConfig config

  scotty (hcPort myConf) $ do
    middleware $ logger (hcEnvironment myConf)

    get "/:word" $ do
         word <- param "word"
         text word
