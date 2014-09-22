{-# LANGUAGE OverloadedStrings #-}

module Http.Routes
    ( routes
    ) where

import Data.Monoid ((<>))
import Web.Scotty

import Http.Params

routes :: ScottyM ()
routes = do
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
