import Graphics.QML
import Data.Text (Text)
import Data.Char
import System.Random (randomRIO)
import Control.Monad.Random
import qualified Data.Text as T

deck :: [String]
deck = [    "C2" , "C3" , "C4" , "C5" , "C6" , "C7" , "C8" , "C9" , "C10" , "CJ" , "CQ" , "CK" , "CA",
            "D2" , "D3" , "D4" , "D5" , "D6" , "D7" , "D8" , "D9" , "D10" , "DJ" , "DQ" , "DK" , "DA",
            "H2" , "H3" , "H4" , "H5" , "H6" , "H7" , "H8" , "H9" , "H10" , "HJ" , "HQ" , "HK" , "HA",
            "S2" , "S3" , "S4" , "S5" , "S6" , "S7" , "S8" , "S9" , "S10" , "SJ" , "SQ" , "SK" , "SA"]

main :: IO ()
main = do
    clazz <- newClass [
        defMethod' "playerMove" (\_ txt ->
            let n = read $ T.unpack txt :: Integer
            in displayPlayerMove n ),
        defMethod' "dealCard" (\_ txt ->
            let n = read $ T.unpack txt :: Int
            in return . T.pack . show $ dealCard n :: IO Text),
        defMethod' "getCardValue" (\_ txt ->
            let n = read $ T.unpack txt :: String
            in return . T.pack . show $ getCardValue n :: IO Text)]
    ctx <- newObject clazz ()
    runEngineLoop defaultEngineConfig {
        initialDocument = fileDocument "mainScrene.qml",
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
        '1'     -> 10 -- Too lazy to handle 10 being two digits
        _       -> digitToInt card

dealCard :: Int -> String
dealCard n = deck !! dealCard' n

dealCard' :: Int -> Int
dealCard' n = let g = mkStdGen n in evalRand (cfunc) g :: Int
  

cfunc = do
  ret <- getRandomR (0,(length deck) - 1)
  return ret

