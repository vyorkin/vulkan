module Render.Names
  ( HasRenderedNames
  , withRenderedNames
  , isStructOrUnion
  , getRenderedStruct
  , isNewtype
  , getResolveAlias
  ) where

import           Relude                  hiding ( ask )
import           Data.List                      ( partition )
import           Polysemy
import           Polysemy.Input
import           Polysemy.Reader
import qualified Data.HashSet                  as Set
import qualified Data.HashMap.Strict           as Map

import           Haskell.Name
import           Render.Element
import           Spec.Types

type HasRenderedNames r = MemberWithError (Input RenderedNames) r

data RenderedNames = RenderedNames
  { rnStructs                :: HashMap HName Struct
  , rnUnions                 :: HashSet HName
  , rnEnums                  :: HashSet HName
  , rnNonDispatchableHandles :: HashSet HName
  , rnDispatchableHandles    :: HashSet HName
  -- , rnConstructorParents     :: HashMap HName HName
  --   -- ^ To import the constructors of a type @T@ we can't just import @T(..)@
  --   -- because @T@ might be a type alias, this maps typenames to resolved
  --   -- typenames.
  , rnResolveAlias           :: HName -> HName
  }

withRenderedNames
  :: HasRenderParams r => Spec -> Sem (Input RenderedNames ': r) a -> Sem r a
withRenderedNames Spec {..} a = do
  RenderParams {..} <- ask
  let
    rnStructs = Map.fromList [(mkTyName . sName $ s, s) | s <-  toList specStructs]
    rnUnions  = Set.fromList (mkTyName . sName <$> toList specUnions)
    rnEnums   = Set.fromList (mkTyName . eName <$> toList specEnums)
    (dispHandles, nonDispHandles) =
      partition ((== Dispatchable) . hDispatchable) $ toList specHandles
    rnDispatchableHandles = Set.fromList (mkTyName . hName <$> dispHandles)
    rnNonDispatchableHandles =
      Set.fromList (mkTyName . hName <$> nonDispHandles)
    aliasMap = Map.fromList
      [ (mkTyName aName, mkTyName aTarget)
      | Alias {..} <- toList specAliases
      , TypeAlias == aType
      ]
    -- TODO: Handle alias cycles!
    rnResolveAlias n = maybe n rnResolveAlias (Map.lookup n aliasMap)
  runInputConst RenderedNames { .. } a

isStructOrUnion :: HasRenderedNames r => HName -> Sem r Bool
isStructOrUnion n = do
  RenderedNames {..} <- input
  let n' = rnResolveAlias n
  pure (Map.member n' rnStructs || Set.member n' rnUnions)

getRenderedStruct :: HasRenderedNames r => HName -> Sem r (Maybe Struct)
getRenderedStruct n = do
  RenderedNames {..} <- input
  let n' = rnResolveAlias n
  pure (Map.lookup n' rnStructs)

isNewtype :: HasRenderedNames r => HName -> Sem r Bool
isNewtype n = do
  RenderedNames {..} <- input
  let n' = rnResolveAlias n
  pure (Set.member n' rnNonDispatchableHandles || Set.member n' rnEnums)

getResolveAlias :: HasRenderedNames r => Sem r (HName -> HName)
getResolveAlias = rnResolveAlias <$> input

