{-# LANGUAGE OverloadedStrings #-}

module Http.Params
    ( Pagination (..)
--    , Limit
--    , Offset
    , paginationA
    , fooA
    , showParamText
    )
where

import qualified Data.Text.Lazy as T
import Web.Scotty

--Deriving Show only for demonstration purposes
newtype Limit = Limit Int deriving (Show)
newtype Offset = Offset Int deriving (Show)
data Pagination = Pagination Limit Offset deriving (Show)

newtype Foo = Foo T.Text deriving (Show)

paginationA :: ActionM Pagination
paginationA = do
  offset' <- param "offset"
  limit' <- param "limit"
  return $ Pagination (Limit limit') (Offset offset')

fooA :: ActionM Foo
fooA = do
  foo' <- param "foo"
  return $ Foo foo'

showParamText :: Show a => a -> T.Text
showParamText a = T.pack (show a)
