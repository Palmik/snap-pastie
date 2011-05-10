{-# LANGUAGE FlexibleContexts #-}

module Model.Utils
    ( fromDocList
    , toDocList
    --
    , insertADT
    , insertADT_
    , insertManyADT
    , insertManyADT_
    --
    , saveADT
    , replaceADT
    , repsertADT
    --
    , restADT
    , nextNADT
    , nextADT
    , groupADT
    ) where

import           Data.Maybe

import           Snap.Extension.DB.MongoDB
import           Snap.Extension.DB.MongoDB.Generics

fromDocList :: (Regular a, FromDoc (PF a)) => [Document] -> [a]
fromDocList = catMaybes . map fromDoc

toDocList :: (Regular a, ToDoc (PF a)) => [a] -> [Document]
toDocList = map toDoc

-- Insert

insertADT :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> a -> m Value
insertADT c = insert c . toDoc

insertADT_ :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> a -> m ()
insertADT_ c adt = insertADT c adt >> return ()

insertManyADT :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> [a] -> m [Value]
insertManyADT c = insertMany c . map toDoc

insertManyADT_ :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> [a] -> m ()
insertManyADT_ c adts = insertManyADT c adts >> return ()

-- Update

saveADT :: (Regular a, ToDoc (PF a), DbAccess m) => Collection -> a -> m ()
saveADT c adt = save c $ toDoc adt

replaceADT :: (Regular a, ToDoc (PF a), DbAccess m) => Selection -> a -> m () -- perhaps replaceWithADT would be better?
replaceADT s adt = replace s $ toDoc adt

repsertADT :: (Regular a, ToDoc (PF a), DbAccess m) => Selection -> a -> m () -- perhaps replaceWithADT would be better?
repsertADT s adt = repsert s $ toDoc adt

--

restADT :: (Regular a, FromDoc (PF a), DbAccess m) => Cursor -> m [a]
restADT c = rest c >>= return . fromDocList

nextNADT :: (Regular a, FromDoc (PF a), DbAccess m) => Int -> Cursor -> m [a]
nextNADT n c = nextN n c >>= return . fromDocList

nextADT :: (Regular a, FromDoc (PF a), DbAccess m) => Cursor -> m (Maybe a)
nextADT c = next c >>= return . (maybe Nothing fromDoc)

groupADT :: (Regular a, FromDoc (PF a), DbAccess m) => Group -> m [a]
groupADT g = group g >>= return . fromDocList


