module Main where
import qualified Utils as Utils
--import System.Console.ANSI
import System.IO
import System.Directory

-- MENU  

main :: IO()
main = do
  putStrLn (Utils.logo)
 -- threadDelay 5000 comando para esperar alguns segundos depois q printar o logo na tela, para depois printar o menu, tbm faz parte do import q n ta pegando
 -- clearScreen  comando de limpeza de tela, não sei pk n tá funcionando aqui, todo o import do System.Console.ANSI n tá pegando na verdade, Vê se tu consegue aí
  menu
  
menu :: IO ()
menu = do
   -- clearScreen
    putStrLn "1 - Cadastrar novo ebook"
    putStrLn "2 - Visualizar lista de ebooks lidos"
    putStrLn "3 - Visualizar lista de ebooks finalizados"
    putStrLn "4 - Marcar um ebook como finalizado"
    putStrLn "5 - Dar nota à um ebook"
    putStrLn "6 - Criar lista de desejos de leitura"
    putStrLn "7 - Visualizar lista de desejos"
    putStrLn "8 - Visuaizar informações sobre ebook"
    putStrLn "Ou Digite 0 Para Sair" 
    putStrLn "\nOpcao: "
    opcao <- getLine
    if (read opcao) == 0
        then 
            putStrLn("Saindo...") 
        else do 
            opcaoEscolhida (read opcao)

-- OPÇÕES 

opcaoEscolhida :: Int -> IO()
opcaoEscolhida opcao 
    | opcao == 1 = do {{-cadastrarLivro-}; menu} -- esse menu nas opções de 1 a 8 tá retornando para o menu, é só p não dar erro, só tirar a medida q formos implementando as funções
    | opcao == 2 = do {{-visualizaLivrosLidos-} ; menu}
    | opcao == 3 = do {{-visualizaLivrosFinalizados-} ; menu}
    | opcao == 4 = do {{-marcaFinalizado-}; menu}
    | opcao == 5 = do {{-notaLivro-}; menu}
    | opcao == 6 = do {{-listaDesejos-}; menu}    
    | opcao == 7 = do {{-visualizaListaDesejos-}; menu}  
    | opcao == 8 = do {{-visualizaInfoLivros-}; menu}  
    | otherwise =  do {putStrLn "Opcao invalida, Porfavor escolha uma opcao valida \n" ; menu}


-- FUNÇÕES BACKEND

data Livro = Livro {
nome :: String,
genero :: String,
ano :: String,
sinopse :: String,
editora :: String,
autor :: String,
nPaginas :: Integer
} deriving (Show)

livros = [Livro { nome = "aa", genero = "aa", ano = "aaaa", sinopse = "aaa", editora = "aaa", autor = "aaaa", nPaginas = 99 }, Livro { nome = "bb", genero = "bb", ano = "bbbb", sinopse = "bbb", editora = "bbb", autor = "bbbb", nPaginas = 987 }]


imprimeTodosLivros :: IO ()
imprimeTodosLivros = do
  putStrLn(listarLivros livros)


listarLivros :: [Livro] -> String
listarLivros [] = ""
listarLivros (x:xs) = toStringLivro x ++ ['\n'] ++ listarLivros xs


toStringLivro :: Livro -> String
toStringLivro (Livro {nome = n, genero = g, ano = a, sinopse = s, editora = e, autor = au, nPaginas = np}) = show n ++ " - " ++ au ++ " - " ++ a


getLivroByIndex :: Int -> [Livro] -> Livro
getLivroByIndex 0 (x:xs) = x
getLivroByIndex n (x:xs) = getLivroByIndex (n-1) xs


addLivroLendo :: Int -> IO ()
addLivroLendo i = appendFile "lendo.txt" (intToFileContent i)


intToFileContent :: Int -> String
intToFileContent numero = ((show numero) ++ "\n")

listarLivrosLendo :: IO [Livro]
listarLivrosLendo = do
  ls <- leituras
  return $ filtraLivros ls livros []


leituras :: IO [Int]
leituras = do
  conteudo <- readFile "lendo.txt"
  let linhas = lines conteudo
  let indexes = fmap (read::String->Int) linhas
  return indexes

finalizados :: IO [Int]
finalizados = do
  conteudo <- readFile "finalizado.txt"
  let linhas = lines conteudo
  let indexes = fmap (read::String->Int) linhas
  return indexes

removerLendo :: Int -> IO ()
removerLendo i = do
  ls <- leituras
  let a = removerLendo' i [] ls 
  removeFile "lendo.txt"
  rebuildLendo a
  appendFile "lendo.txt" ""
  where
    removerLendo' :: Int -> [Int] -> [Int] -> [Int]
    removerLendo' i filtered (x:xs)
      |  i == x = filtered ++ xs
      | otherwise = removerLendo' i (filtered ++ [x]) xs

rebuildLendo :: [Int] -> IO ()
rebuildLendo [] = return ()
rebuildLendo (x:xs) = do 
  addLivroLendo x
  rebuildLendo xs

finalizaLivro :: Int -> IO()
finalizaLivro i = do
  removerLendo i
  addLivroFinalizado i

addLivroFinalizado :: Int -> IO ()
addLivroFinalizado i = appendFile "finalizado.txt" (intToFileContent i)

listarLivrosFinalizados :: IO [Livro]
listarLivrosFinalizados = do
  ls <- finalizados
  return $ filtraLivros ls livros []

filtraLivros :: [Int] -> [Livro] -> [Livro] -> [Livro]
filtraLivros [] livros livrosFiltrados = livrosFiltrados
filtraLivros (x:xs) livros livrosFiltrados = filtraLivros xs livros (livrosFiltrados ++ [getLivroByIndex x livros])