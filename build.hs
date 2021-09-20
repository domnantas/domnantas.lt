import Data.List
import System.Directory
import System.FilePath
import System.IO

domain = "https://domnantas.lt/"

title = "domnantas"

main = do
  absoluteSourcePath <- makeAbsolute "content"
  absoluteOutputPath <- makeAbsolute "dist"
  absoluteStaticPath <- makeAbsolute "static"

  -- Cleanup
  removePathForcibly absoluteOutputPath
  createDirectory absoluteOutputPath

  -- Copy static files
  staticFiles <- listDirectory absoluteStaticPath
  mapM_ (\fileName -> copyFile (absoluteStaticPath </> fileName) (absoluteOutputPath </> fileName)) staticFiles

  fileList <- listDirectory absoluteSourcePath
  let fileNameList = map takeBaseName $ filter (isExtensionOf ".htm") fileList
  putStrLn $ "indexed " ++ show (length fileNameList) ++ " terms"

  mapM_ (build absoluteSourcePath absoluteOutputPath) fileNameList

build sourcePath outputPath fileName = do
  let sourceFilePath = sourcePath </> fileName <.> "htm"
  let outputFilePath = outputPath </> fileName <.> "html"
  withFile
    sourceFilePath
    ReadMode
    ( \handle -> do
        contents <- hGetContents handle
        withFile
          outputFilePath
          WriteMode
          ( \handle -> do
              hPutStrLn handle "<!DOCTYPE html><html lang='en'>"
              hPutStrLn handle "<head>"
              hPutStrLn handle "<meta charset='utf-8'>"
              -- hPutStrLn handle $ "<meta name='thumbnail' content='" ++ domain ++ "media/services/thumbnail.jpg' />"
              hPutStrLn handle "<meta name='viewport' content='width=device-width,initial-scale=1'>"
              -- hPutStrLn handle "<link rel='alternate' type='application/rss+xml' title='RSS Feed' href='../links/rss.xml' />"
              hPutStrLn handle "<link rel='stylesheet' type='text/css' href='/style.css' />"
              -- hPutStrLn handle "<link rel='shortcut icon' type='image/png' href='../media/services/shortcut.png'>"
              hPutStrLn handle $ "<title>" ++ title ++ " &mdash; " ++ fileName ++ "</title>"
              hPutStrLn handle "</head>"
              hPutStrLn handle "<body>"
              hPutStrLn handle contents
              hPutStrLn handle "</body></html>"
          )
        putStrLn $ "built " ++ fileName
    )