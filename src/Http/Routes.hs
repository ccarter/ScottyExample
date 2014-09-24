{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module Http.Routes
    ( routes
    ) where

import Data.Monoid ((<>))
import qualified Data.Text as T
import Web.Scotty

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Reader (runReaderT)
import Database.Queries
import Http.Params


routes :: T.Text -> ScottyM ()
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
