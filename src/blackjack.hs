{-# LANGUAGE DeriveDataTypeable, TypeFamilies, OverloadedStrings #-}
import Graphics.QML
import Graphics.QML.Debug
import Graphics.QML.Objects
import Control.Concurrent
import Data.Text (Text)
import Data.Proxy
import Data.Typeable
import Data.Char
import System.Random (randomRIO)
import Control.Monad.State.Lazy
import Control.Monad.Random
import System.Random
import qualified Data.Text as T

--Haskell representation of Dealer Hand
data ContextObj = ContextObj
                { _list :: MVar [ObjRef ListItem]
                } deriving Typeable

--Haskell representation of Player Hand
data ContextObj2 = ContextObj2
                 { _list2 :: MVar [ObjRef ListItem]
                 } deriving Typeable

--Haskell representation of the blackjack gamestate
data GameState = GameState
               { _dealHand :: ObjRef ContextObj,
                 _playHand :: ObjRef ContextObj2
               } deriving Typeable

--Haskell representation of a Card
data ListItem = ListItem
              { _text :: T.Text,
                _text3 :: T.Text
              } deriving Typeable

--Signal for our custom Haskell type
data ListChanged deriving Typeable

--Class instance of our signal
instance SignalKeyClass ListChanged where
   type SignalParams ListChanged = IO ()

--Default class for Gamestate
instance DefaultClass GameState where
    classMembers = [
         defPropertySigRO "dealer" (Proxy :: Proxy ListChanged) $ return . _dealHand . fromObjRef,
         defPropertySigRO "player" (Proxy :: Proxy ListChanged) $ return . _playHand . fromObjRef,
         defMethod "finalScore" finalScore,
         defMethod "scoreDealerExternal" scoreDealerExternal
         ]

--Default class for Dealer Hand
instance DefaultClass ContextObj where
    classMembers = [
         defPropertySigRO "list" (Proxy :: Proxy ListChanged) $ readMVar . _list . fromObjRef,
         defMethod "appendList" appendList,
         defMethod "appendFirst" appendFirst,
         defMethod "flipFirst" flipFirst,
         defMethod "scoreDealer" scoreDealer,
         defMethod "clear" clearDealer
         ]

--Default class for Player Hand
instance DefaultClass ContextObj2 where
    classMembers = [
         defPropertySigRO "list2" (Proxy :: Proxy ListChanged) $ readMVar . _list2 . fromObjRef,
         defMethod "appendList2" appendList2,
         defMethod "scorePlayer" scorePlayer,
         defMethod "clear" clearPlayer
         ]

--Generate victory message for player
genPlayerVictory :: Int -> Int -> IO(Text)
genPlayerVictory s1 s2 = let msg = foldr (++) "" ["Player"," ","wins"," ","with"," ", show s1, " ", "to", " ", show s2] in
                         do return . T.pack $ msg

--Generate victory message for dealer
genDealerVictory :: Int -> Int -> IO(Text)
genDealerVictory s1 s2 = let msg = foldr (++) "" ["Dealer"," ","wins"," ","with"," ",show s2, " ", "to", " ",show s1] in
                         do return . T.pack $ msg

--Generate bust mesage for player
genPlayerBust :: Int -> IO(Text)
genPlayerBust s = let msg = foldr (++) "" ["Player", " ", "bust", " ", "with", " ",show s,", ","Dealer"," ","wins"] in
                  do return . T.pack $ msg

--Generate bust message for dealer
genDealerBust :: Int -> IO(Text)
genDealerBust s = let msg = foldr (++) "" ["Dealer", " ", "bust", " ","with", " ",show s, ", ","Player", " ","wins"] in
                  do return . T.pack $ msg

--Generate bust message for both
genDoubleBust :: IO(Text)
genDoubleBust = let msg = foldr (++) "" ["Both"," ","players"," ","bust"," no", " one", " wins"] in
                do return . T.pack $ msg

--Generate a tie message
genTie :: Int -> IO(Text)
genTie s = let msg = foldr (++) "" ["It's"," ","a"," ","tie"," ","with"," ","score"," ",show s] in
           do return . T.pack $ msg

--Put the score of a Hand into the IO Monad
getScore :: Int -> IO(Int)
getScore s = do return s

--Final scoring of the blackjack gamestate
--Returns a victory message depending on the hand scores
finalScore :: ObjRef GameState -> IO (Text)
finalScore co = do deal <- scoreDealer dealHand
                   play <- scorePlayer playHand
                   score1 <- getScore $ read $T.unpack deal
                   score2 <- getScore $ read $T.unpack play
                   playerWin <- genPlayerVictory (read $ T.unpack play) (read $ T.unpack deal)
                   dealerWin <- genDealerVictory (read $ T.unpack play) (read $ T.unpack deal)
                   tie <- genTie score1
                   if ((score1 > score2) && (score1 <= 21)) then return dealerWin else (if ((score2 > score1) && (score2 <= 21)) then return playerWin else (if ((score2 == score1) && (score1 <= 21)) then return tie else (if ((score1 > 21) && (score2 <= 21)) then genDealerBust score1 else (if ((score2 > 21) && (score1 <= 21)) then genPlayerBust score2 else genDoubleBust))))
   where dealHand = _dealHand . fromObjRef $ co
         playHand = _playHand . fromObjRef $ co

--Clears the dealer's hand
clearDealer :: ObjRef ContextObj -> IO ()
clearDealer co = modifyMVar_ list (\ls -> do return [])
    where list = _list . fromObjRef $ co

--Clears the player's hand
clearPlayer :: ObjRef ContextObj2 -> IO ()
clearPlayer co = modifyMVar_ list (\ls -> do return [])
    where list = _list2 . fromObjRef $ co

--Scores a hand
--Returns minimum value of ace if one of the values is above 21, the maximum value otherwise
--Currently, doesn't handle the case of multiple aces in a hand (where they could be different values to maximize the score)
scoreHand :: [ObjRef ListItem] -> IO(Int)
scoreHand lst = let min_score = foldr (+) 0 (map (\i -> if i == -1 then 1 else i) (map (\x -> let (ListItem{_text=y,_text3=z}) = fromObjRef x in getCardValue (T.unpack z)) lst)) in
                let max_score = foldr (+) 0 (map (\i -> if i == -1 then 11 else i) (map (\x -> let (ListItem{_text=y,_text3=z}) = fromObjRef x in getCardValue (T.unpack z)) lst)) in
                do if ((min_score <= 21) && (max_score <= 21)) then return max_score else return min_score

--Scores the dealer's hand- passes off to scoreHand
scoreDealer :: ObjRef ContextObj -> IO (Text)
scoreDealer co = do lst <- readMVar . _list . fromObjRef $ co
                    score <- scoreHand lst
                    return . T.pack . show $ score

scoreDealerExternal :: ObjRef GameState -> IO (Text)
scoreDealerExternal co = scoreDealer (_dealHand . fromObjRef $ co)

--Scores the player's hand- passes off to scoreHand
scorePlayer :: ObjRef ContextObj2 -> IO (Text)
scorePlayer co = do lst <- readMVar . _list2 . fromObjRef $ co
                    score <- scoreHand lst
                    return . T.pack . show $ score

--Append an element to the end of a list
appendToEnd :: [a] -> a -> [a]
appendToEnd xs x = foldr (:) [x] xs

--Flips a card by replacing the src from cardBack image to the proper card image
transform item = let alt_x = T.pack (foldr (++) "" ["../Images/",T.unpack(y),".png"]) in
                 let new_x = if (x== "../Images/cardBack.jpg") then alt_x else x in
                 do newObjectDC $ ListItem new_x y
    where (ListItem{_text=x,_text3=y}) = item

--Replaces first element in a list
replaceFirst :: [a] -> a -> [a]
replaceFirst (x:xs) y = y:xs

--Flips the first card of the dealer's hand (which was dealt face down)
--Notifies QML that the list has changed
flipFirst :: ObjRef ContextObj -> IO ()
flipFirst co = modifyMVar_ list (\ls -> do l <- transform $fromObjRef $head ls
                                           return (replaceFirst ls l)) >>
               fireSignal (Proxy :: Proxy ListChanged) co
    where list = _list . fromObjRef $ co

--Appends a card to the Player's Hand
--Seeded with a value from QML javascript
--Notifies QML that the list has changed
appendList2 :: ObjRef ContextObj2 -> Int -> IO ()
appendList2 co num = let dealtCard = deck !! num2 in
                     let txt = foldr (++) "" ["../Images/",dealtCard,".png"] in
                     modifyMVar_ list (\ls -> do l <- newObjectDC $ ListItem (T.pack txt) (T.pack dealtCard)
                                                 --return (l:ls)) >>
                                                 return (appendToEnd ls l)) >>
                     fireSignal (Proxy :: Proxy ListChanged) co
    where list = _list2 . fromObjRef $ co
          num2 = head $ snd $ splitAt (num) $ evalState values $mkStdGen $ dealCard' (num*(num-1)*(num+30))

--Default class instance for a Card
instance DefaultClass ListItem where
    classMembers = [
         defPropertyConst "text" $ return . _text . fromObjRef,
         defPropertyConst "text3" $ return . _text . fromObjRef
         ]

--Deals a card face down to the Dealer's hand
--Seeded from QML with a random number
--Notifies QML that the list has changed
appendFirst :: ObjRef ContextObj -> Int -> IO ()
appendFirst co num = let dealtCard = deck !! num2 in
                     modifyMVar_ list (\ls -> do l <- newObjectDC $ ListItem (T.pack "../Images/cardBack.jpg") (T.pack dealtCard)
                                                 return (appendToEnd ls l)) >>
                     fireSignal (Proxy :: Proxy ListChanged) co
    where list = _list . fromObjRef $ co
          num2 = head $ snd $ splitAt (num) $ evalState values $mkStdGen $ dealCard' (num*(num-1)*(num+30))

--Deals a card face up to the Dealer's hand
--Seeded from QML with a random number
appendList :: ObjRef ContextObj -> Int -> IO ()
appendList co num = let dealtCard = deck !! num2 in 
                    let txt = foldr (++) "" ["../Images/",dealtCard,".png"] in
                    modifyMVar_ list (\ls -> do l <- newObjectDC $ ListItem (T.pack txt) (T.pack dealtCard)
                                                return (appendToEnd ls l)) >>
                    fireSignal (Proxy :: Proxy ListChanged) co
    where list = _list . fromObjRef $ co
          num2 = head $ snd $ splitAt (num) $ evalState values $mkStdGen $ dealCard' (num*(num-1)*(num+30))

deck :: [String]
deck = [    "C2" , "C3" , "C4" , "C5" , "C6" , "C7" , "C8" , "C9" , "C10" , "CJ" , "CQ" , "CK" , "CA",
            "D2" , "D3" , "D4" , "D5" , "D6" , "D7" , "D8" , "D9" , "D10" , "DJ" , "DQ" , "DK" , "DA",
            "H2" , "H3" , "H4" , "H5" , "H6" , "H7" , "H8" , "H9" , "H10" , "HJ" , "HQ" , "HK" , "HA",
            "S2" , "S3" , "S4" , "S5" , "S6" , "S7" , "S8" , "S9" , "S10" , "SJ" , "SQ" , "SK" , "SA"]

deckunsorted = ["HJ","DQ","S7","SK","H7","D8","C2","HA","CK","H9","S3","S2","D10","SJ","D7","DA","H8","HK","C3","SQ","D4","CQ","C6","H6","C5","H3","D5","D3","S6","HQ","C10","D6","CJ","H2","S4","C8","C4","D2","H5","DK","C9","CA","H10","C7","DJ","H4","S9","S5","SA","D9","S10","S8"]

main :: IO ()
main = do
   -- l <- setDebugLogLevel 1
    l <- newMVar []
    z <- newMVar []
    ll <- newObjectDC $ ContextObj l 
    zz <- newObjectDC $ ContextObj2 z
    ctx <- newObjectDC $ GameState ll zz
    runEngineLoop defaultEngineConfig {
        initialDocument = fileDocument "./src/qml/MainScreen.qml",
        contextObject = Just $ anyObjRef ctx}

displayPlayerMove :: Integer -> IO ()
displayPlayerMove n = case n of 
    0 -> putStrLn "Hit" :: IO ()
    1 -> putStrLn "Stay":: IO ()

getCardValue :: String -> Int 
getCardValue str = 
    let card = str !! 1
    in case card of 
        'A'     -> -1
        'K'     -> 10
        'Q'     -> 10
        'J'     -> 10
        '1'     -> 10 
        _       -> digitToInt card

dealCard :: Int -> String
dealCard n = deck !! dealCard' n

dealCard' :: Int -> Int
dealCard' n = let g = mkStdGen n in evalRand (cfunc) g :: Int
  

cfunc = do
  ret <- getRandom--R (0,(length deck) - 1)
  return ret

myRand :: State StdGen Int
myRand = do
           gen <- get
           let (r,nextGen) = randomR (0,51) gen
           put nextGen
           return r 

values = mapM (\_ -> myRand ) $ repeat ()

