{-# LANGUAGE OverloadedStrings #-}

module Config.Conf
    ( DbName(..)
    , MyConfig(..)
    , Environment(..)
    , HttpConfig(..)
    , EkgConfig(..)
    , loadMyConfig
    )
where

import qualified Data.Configurator as C
import qualified Data.Configurator.Types as CT
import qualified Data.ByteString as BS
import qualified Data.Text as T


newtype DbName = DbName T.Text
type Port = Int

data HttpConfig = HttpConfig { hcPort :: Port }

data EkgConfig = EkgConfig { ecHost :: BS.ByteString
                           , ecPort :: Port }

data Environment = Development | Other

data MyConfig = MyConfig { mcHttp :: HttpConfig
                         , mcEkg :: EkgConfig
                         , mcEnvironment :: Environment
                         , mcDbName :: DbName }

loadMyConfig :: FilePath -> IO MyConfig
loadMyConfig filePath = do
  config <- C.load [C.Required filePath]
  myConfig config

myConfig :: CT.Config -> IO MyConfig
myConfig c = do
  httpConf <- httpConfig c
  ekgConf <- ekgConfig c
  env' <- C.require c "environment"
  dbName <- C.require c "dbName"
  return $ MyConfig httpConf ekgConf (env env') (DbName dbName)

httpConfig :: CT.Config -> IO HttpConfig
httpConfig c = do
  let subConf = C.subconfig "http" c
  port <- C.require subConf "port"
  return $ HttpConfig port

ekgConfig :: CT.Config -> IO EkgConfig
ekgConfig c = do
  let subConf = C.subconfig "ekg" c
  host <- C.require subConf "host"
  port <- C.require subConf "port"
  return $ EkgConfig host port

env :: String -> Environment
env e = case e of
          "development" -> Development
          _ -> Other
