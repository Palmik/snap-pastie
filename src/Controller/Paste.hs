{-# LANGUAGE FlexibleContexts #-}

module Controller.Paste
( recentPastesSplice
) where
    
import qualified Data.Text    as T

import           Text.Templating.Heist

import           Application        
import           Model.Paste


pasteParts :: Paste -> [(T.Text, T.Text)]
pasteParts paste = map applyAndPack [ ("title", pasteTitle)
                                    , ("content", pasteContent)
                                    , ("description", pasteDescription)
                                    , ("language", pasteLanguage) ]
    where applyAndPack (x, f) = (T.pack x, T.pack $ f paste)

-- recentPastesSplice :: Splice Application
recentPastesSplice :: (Monad m, DbAccess (TemplateMonad m), MonadMongoDB (TemplateMonad m)) => Splice m
recentPastesSplice = do
    pastes <- getRecentPastes
    mapSplices (runChildrenWithText . pasteParts) pastes