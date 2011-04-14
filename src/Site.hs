{-# LANGUAGE OverloadedStrings #-}

{-|

This is where all the routes and handlers are defined for your site. The
'site' function combines everything together and is exported by this module.

-}

module Site
( site
) where

import           Control.Applicative
import           Control.Monad
import           Debug.Trace
import           Control.Monad.Trans
import           Data.Maybe
import qualified Data.Text.Encoding as T

import           Snap.Extension.DB.MongoDB (bs2objid)
import           Snap.Extension.Heist
import           Snap.Extension.Timer
import           Snap.Util.FileServe
import           Snap.Types
import           Text.Templating.Heist

import           Application
import           Controller.Paste

------------------------------------------------------------------------------
-- | Render recent pastes
pastes :: Application ()
pastes = ifTop $ heistLocal (bindSplices pastesSplices) $ render "pastes"
    where
      pastesSplices =
          [ ("recent-pastes", recentPastesSplice)
          , ("possible-languages", possibleLanguagesSplice)
          ]

------------------------------------------------------------------------------
-- | Render single paste
paste :: Application ()
paste = do
    oid <- liftM bs2objid $ decodedParam "oid"    
    let pasteSplices = [ ("single-paste",       singlePasteSplice oid)
                       , ("possible-languages", possibleLanguagesSplice)
                       ]
    ifTop $ heistLocal (bindSplices pasteSplices) $ render "paste"
    where
      decodedParam p = fromMaybe "" <$> getParam p
    
------------------------------------------------------------------------------
-- | The main entry point handler.
site :: Application ()
site = route [ ("/paste/:oid",                    paste)
             , ("/pastes",                        pastes)
             , ("/",          method   POST       addPasteHandler)
             , ("/",          methods [GET, HEAD] index)
             ]
       <|> serveDirectory "resources/static"