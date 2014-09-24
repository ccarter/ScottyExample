{-# LANGUAGE OverloadedStrings #-}

module Http.Routes
    ( routes
    ) where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Reader (runReaderT)
import Data.Monoid ((<>))
import Web.Scotty

import Config.Conf (DbName(..))
import Database.Queries
import Http.Params


routes :: DbName -> ScottyM ()
routes dbName = do
  get "/route1" $ do
           fooParam <- fooA
           text $ showParamText fooParam

  get "/route2" $ do
           fooParam <- fooA
           pagination <- paginationA
           text $ showParamText fooParam <> showParamText pagination

  get "/route3" $ do
           fooParam <- fooA
           pagination <- paginationA
           text $ showParamText fooParam <> showParamText pagination

  post "/persons" $ do
           person <- jsonData
           person' <- liftIO $ runReaderT (insertPerson person) dbName
           json person'

  get "/persons" $ do
           persons' <- liftIO $ runReaderT persons dbName
           json persons'
