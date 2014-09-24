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
  myConf <- loadMyConfig "config/config.cfg"
  startEkg (mcEkg myConf)
  migrateDb' (mcDbName myConf)
  startApp myConf

startEkg :: EkgConfig -> IO ()
startEkg ekgConfig = void $ forkServer (ecHost ekgConfig) (ecPort ekgConfig)

migrateDb' :: DbName -> IO ()
migrateDb' = runReaderT migrateDb

startApp :: MyConfig -> IO ()
startApp myConf =
    scotty (hcPort (mcHttp myConf)) $ do
      middleware $ logger (mcEnvironment myConf)
      routes (mcDbName myConf)
