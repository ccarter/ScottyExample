module Database.Queries
    ( persons
    , personsByFirstName
    , insertPerson
    , migrateDb
    )
where

import Control.Monad.Logger
import Control.Monad.Trans.Resource (runResourceT, ResourceT)
import qualified Data.Text as T
import Database.Persist.Sqlite

import Database.Models


type DbName = T.Text

persons :: DbName ->  IO [Entity Person]
persons dbName = runDb dbName $ selectList [] []

personsByFirstName :: DbName -> T.Text -> IO [Entity Person]
personsByFirstName dbName fn = runDb dbName $ selectList [PersonFirstName ==. fn] [Desc PersonFirstName]

insertPerson :: DbName -> Person -> IO (Key Person)
insertPerson dbName person = runDb dbName $ insert person

runDb :: DbName -> SqlPersistT (ResourceT (NoLoggingT IO)) a -> IO a
runDb dbName query = runNoLoggingT . runResourceT . withSqliteConn dbName . runSqlConn $ query

migrateDb :: DbName -> IO ()
migrateDb dbName = runDb dbName $ runMigration migrateAll
