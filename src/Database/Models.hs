{-# LANGUAGE EmptyDataDecls       #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Database.Models where

import Control.Monad (mzero)
import Data.Aeson
import qualified Data.Text as T
import Database.Persist
import Database.Persist.TH


share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistUpperCase|
Person
    firstName T.Text
    lastName T.Text
    address T.Text

|]

instance FromJSON Person where
    parseJSON (Object v) = do
                           fn <- v .: "firstName"
                           ln <- v .: "lastName"
                           add <- v.: "address"
                           return $ Person fn ln  add

    parseJSON _ = mzero

instance ToJSON Person where
    toJSON (Person fname lname address) =
        object ["firstName" .= fname, "lastName" .= lname, "address" .= address]

instance ToJSON a => ToJSON (Entity a) where
    toJSON (Entity k a) = object ["id" .= k, "value" .= toJSON a]
