{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (void)
import Control.Monad.Reader (runReaderT)
import System.Remote.Monitoring
import Web.Scotty

import Config.Conf
import Config.Logger
import Database.Queries (migrateDb)
import Http.Routes


main :: IO ()
main = do
  config <- load configFiles
  myConf <- myConfig config
  let httpConfig = mcHttp myConf
  let ekgConfig = mcEkg myConf
  let dbName = mcDbName myConf

  runReaderT migrateDb dbName

  void $ forkServer (ecHost ekgConfig) (ecPort ekgConfig)

  scotty (hcPort httpConfig) $ do
    middleware $ logger (mcEnvironment myConf)
    routes dbName
