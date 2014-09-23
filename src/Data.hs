{-# LANGUAGE OverloadedStrings #-}

module Data
    ( Person(..)
    )
where


import Control.Monad (mzero)
import Data.Aeson
import qualified Data.Text as T

newtype FirstName = FirstName T.Text
newtype LastName = LastName T.Text
newtype Address = Address T.Text
data Person = Person FirstName LastName Address


--Note using Monad for in following code. Applicative would look like the following
--import Control.Applicative ((<$>), liftA3)
--
--  liftA3 Person
--    (FirstName <$> (v .: "firstName"))
--    (LastName <$> (v .: "lastName"))
--    (Address <$> (v .: "address"))

instance FromJSON Person where
    parseJSON (Object v) = do
                           fn <- v .: "firstName"
                           ln <- v .: "lastName"
                           add <- v.: "address"
                           return $ Person (FirstName fn) (LastName ln) (Address add)

    parseJSON _ = mzero

instance ToJSON Person where
    toJSON (Person (FirstName fname) (LastName lname) (Address address)) =
        object ["firstName" .= fname, "lastName" .= lname, "address" .= address]
