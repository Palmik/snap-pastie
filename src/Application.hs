{-# LANGUAGE OverloadedStrings #-}

{-

This module defines our application's monad and any application-specific
information it requires.

-}

module Application
    ( Application
    , applicationInitializer
    ) where

import           Snap.Extension
import           Snap.Extension.Heist.Impl
import           Snap.Extension.DB.MongoDB


------------------------------------------------------------------------------
-- | 'Application' is our application's monad. It uses 'SnapExtend' from
-- 'Snap.Extension' to provide us with an extended 'MonadSnap' making use of
-- the Heist and MongoDB Snap extensions.
type Application = SnapExtend ApplicationState


------------------------------------------------------------------------------
-- | 'ApplicationState' is a record which contains the state needed by the Snap
-- extensions we're using.
data ApplicationState = ApplicationState
    { templateState :: HeistState Application
    , databaseState :: MongoDBState
    }


------------------------------------------------------------------------------
instance HasHeistState Application ApplicationState where
    getHeistState     = templateState
    setHeistState s a = a { templateState = s }

------------------------------------------------------------------------------
instance HasMongoDBState ApplicationState where
    getMongoDBState     = databaseState
    setMongoDBState s a = a { databaseState = s }

------------------------------------------------------------------------------
-- | The 'Initializer' for ApplicationState. For more on 'Initializer's, see
-- the documentation from the snap package. Briefly, this is used to
-- generate the 'ApplicationState' needed for our application and will
-- automatically generate reload\/cleanup actions for us which we don't need
-- to worry about.
applicationInitializer :: Initializer ApplicationState
applicationInitializer = do
    heist <- heistInitializer "resources/templates"
    database <- mongoDBInitializer (Host "127.0.0.1" $ PortNumber 27017) 1 "pastie"
    return $ ApplicationState heist database