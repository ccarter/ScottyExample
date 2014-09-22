{-# LANGUAGE OverloadedStrings #-}

module Http.Routes
    ( routes
    ) where

import Data.Monoid ((<>))
import Web.Scotty

routes :: ScottyM ()
routes = do
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
