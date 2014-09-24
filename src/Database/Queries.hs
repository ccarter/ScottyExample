module Database.Queries
    ( persons
    , personsByFirstName
    , insertPerson
    , migrateDb
    )
where

import Control.Monad.Logger
import Control.Monad.Reader
import Control.Monad.Trans.Resource (runResourceT, ResourceT)
import qualified Data.Text as T
import Database.Persist.Sqlite

import Database.Models


type DbName = T.Text
type DbAction = ReaderT DbName IO

persons :: DbAction [Entity Person]
persons = runDb $ selectList [] []

personsByFirstName :: T.Text -> DbAction [Entity Person]
personsByFirstName fn = runDb $ selectList [PersonFirstName ==. fn] [Desc PersonFirstName]

insertPerson :: Person -> DbAction (Key Person)
insertPerson person = runDb $ insert person

runDb :: SqlPersistT (ResourceT (NoLoggingT IO)) a -> DbAction a
runDb query = do
  dbName <- ask
  liftIO $ runNoLoggingT . runResourceT . withSqliteConn dbName . runSqlConn $ query

migrateDb :: DbAction ()
migrateDb = runDb $ runMigration migrateAll
