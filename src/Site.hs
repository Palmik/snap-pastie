{-# LANGUAGE OverloadedStrings #-}

{-|

This is where all the routes and handlers are defined for your site. The
'site' function combines everything together and is exported by this module.

-}

module Site
( site
) where

import           Control.Applicative
import           Data.Maybe
import qualified Data.Text.Encoding as T
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
          ]

------------------------------------------------------------------------------
-- | The main entry point handler.
site :: Application ()
site = route [ ("/",      methods [GET, HEAD] pastes)
             , ("/",      method  POST        addPasteHandler)
             ]
       <|> serveDirectory "resources/static"