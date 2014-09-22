{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Monoid ((<>))
import Web.Scotty

import Config.Conf
import Config.Logger

main :: IO ()
main = do
  config <- load configFiles
  myConf <- myConfig config

  scotty (hcPort myConf) $ do
    middleware $ logger (hcEnvironment myConf)

    get "/route1" $ do
         fooParam <- param "foo"
         text fooParam

    get "/route2" $ do
         fooParam <- param "foo"
         limit <- param "limit"
         offset <- param "offset"
         text $ fooParam <> limit <> offset

    get "/route3" $ do
         fooParam <- param "foo"
         limit <- param "limit"
         offset <- param "offset"
         text $ fooParam <> limit <> offset
