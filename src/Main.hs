{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty

import Config.Conf

main :: IO ()
main = do
  config <- load configFiles
  httpConf <- httpConfig config

  scotty (hcPort httpConf) $
         get "/:word" $ do
           word <- param "word"
           text word
