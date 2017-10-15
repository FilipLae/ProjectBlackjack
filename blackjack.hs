import Graphics.QML
import Data.Text (Text)
import qualified Data.Text as T

main :: IO ()
main = do
    clazz <- newClass [
        defMethod' "factorial" (\_ txt ->
            let n = read $ T.unpack txt :: Integer
            in return . T.pack . show $ product [1..n] :: IO Text)]
    ctx <- newObject clazz ()
    runEngineLoop defaultEngineConfig {
        initialDocument = fileDocument "blackjack.qml",
        contextObject = Just $ anyObjRef ctx}