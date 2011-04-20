{-# LANGUAGE FlexibleContexts #-}

module Model.Utils
    ( fromDocList
    , insertADT
    , insertADT_
    , insertManyADT
    , insertManyADT_
    , restADT
    , nextNADT
    , nextADT
    ) where

import           Data.Maybe

import           Snap.Extension.DB.MongoDB
import           Snap.Extension.DB.MongoDB.Generics

fromDocList :: (Regular a, FromDoc (PF a)) => [Document] -> [a]
fromDocList = catMaybes . map fromDoc

insertADT :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> a -> m Value
insertADT c = insert c . toDoc

insertADT_ :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> a -> m ()
insertADT_ c adt = insertADT c adt >> return ()

insertManyADT :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> [a] -> m [Value]
insertManyADT c = insertMany c . map toDoc

insertManyADT_ :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> [a] -> m ()
insertManyADT_ c adts = insertManyADT c adts >> return ()

restADT :: (Regular a, FromDoc (PF a), DbAccess m) => Cursor -> m [a]
restADT c = rest c >>= return . fromDocList

nextNADT :: (Regular a, FromDoc (PF a), DbAccess m) => Int -> Cursor -> m [a]
nextNADT n c = nextN n c >>= return . fromDocList

nextADT :: (Regular a, FromDoc (PF a), DbAccess m) => Cursor -> m (Maybe a)
nextADT c = next c >>= return . (maybe Nothing fromDoc)
