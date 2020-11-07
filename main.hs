module Main where
import qualified Utils as Utils
import System.IO.Unsafe(unsafeDupablePerformIO)
import System.Console.ANSI
import System.IO
import System.Directory

-- MENU

main :: IO()
main = do
    putStrLn (Utils.logo)
    --threadDelay 5000
    menu

menu :: IO ()
menu = do
    putStrLn "1 - Cadastrar novo ebook lendo: "
    putStrLn "2 - Visualizar lista de ebooks lendo: "
    putStrLn "3 - Visualizar lista de ebooks finalizados: "
    putStrLn "4 - Marcar um ebook como finalizado: "
    putStrLn "5 - Adicionar livro à lista de desejos de leitura: "
    putStrLn "6 - Visualizar lista de desejos: "
    putStrLn "7 - Visuaizar informações sobre ebooks do sistema: " -- aqui pega só os estáticos
    putStrLn "Ou Digite 0 Para Sair: "
    putStrLn "\nOpcao: "
    opcao <- getLine
    opcaoEscolhida (read opcao)

-- OPÇÕES

opcaoEscolhida :: Int -> IO()
opcaoEscolhida opcao
    | opcao == 1 = do {cadastrarLivro ; menu}
    | opcao == 2 = do {visualizaLivrosLendo ; menu}
    | opcao == 3 = do {visualizaLivrosFinalizados; menu}
    | opcao == 4 = do {marcaFinalizado; menu}
    | opcao == 5 = do {enviarLivroDesejado; menu}
    | opcao == 6 = do {visualizaDesejos; menu}
    | opcao == 7 = do {livroDetail; menu}
    | opcao == 0 = do {putStrLn "Saindo..."}
    | otherwise =  do {putStrLn "Opcao invalida, Porfavor escolha uma opcao valida \n" ; menu}


-- FUNÇÕES BACKEND

data Livro = Livro {
indice :: Integer,
nome :: String,
genero :: String,
ano :: String,
sinopse :: String,
editora :: String,
autor :: String,
nPaginas :: Integer
} deriving (Show)

-- Já disponíveis no sistema

livros = [Livro { indice = 0, nome = "Harry potter e o calice de fogo", genero = "Fantasia", ano = "2001", sinopse = "A chegada na Escola e a notícia de que esta sediará o importante Torneio Tribruxo.", editora = "Rocco", autor = "J.K. Rowling", nPaginas = 584},
          Livro { indice = 1, nome = "Harry potter e o enigma do principe", genero = "Fantasia", ano = "2005", sinopse = "Um misterioso príncipe mestiço ajuda Harry em sua aula de Poções.", editora = "Rocco", autor = "J.K. Rowling", nPaginas = 512},
          Livro { indice = 2, nome = "A revolucao dos bichos: Um conto de fadas", genero = "Infantil", ano = "2007", sinopse = "Intrigante narrativa protagonizada geralmente por animais, mas que reflete ações humanas com algum ensinamento de cunho moral." , editora = "Companhia das Letras", autor = "George Orwell", nPaginas = 152},
          Livro { indice = 3, nome = "O iluminado", genero = "Terror/Romance", ano = "2012", sinopse = "A luta assustadora entre dois mundos. Um menino e o desejo assassino de poderosas forças malignas." , editora = "Suma", autor = " Stephen King", nPaginas = 464 },
          Livro { indice = 4, nome = "Sherlock Holmes - Um estudo em vermelho", genero = "Acao e Aventura", ano = "2019", sinopse = "Holmes é chamado para solucionar o caso de um homem que foi encontrado morto, com uma expressão de terror, mas que não apresenta ferimentos, apenas manchas de sangue pelo corpo." , editora = "Principis", autor = "Arthur Conan Doyle", nPaginas = 176 }]


livroDetail :: IO ()
livroDetail = do
  Utils.printEspaco
  imprimeTodosLivros
  putStrLn "Digite o id do livro que você quer mais detalhes: "
  i <- getLine
  let l = getLivroByIndex (read i) livros
  putStrLn(toStringLivroDetail l)
  Utils.printEspaco

marcaFinalizado :: IO()
marcaFinalizado = do
  Utils.printEspaco
  putStrLn "Você está lendo esses livros: "
  visualizaLivrosLendo
  putStrLn "Digite o id do livro que quer marcar como finalizado: "
  f <- getLine
  putStrLn "Digite uma nota para o livro: "
  n <- getLine
  finalizaLivro (read f) (read n)
  Utils.printEspaco

visualizaLivrosFinalizados :: IO()
visualizaLivrosFinalizados = do
  Utils.printEspaco
  l <- listarLivrosFinalizados
  n <- notas
  putStrLn (listarLivrosNotas l n)
  Utils.printEspaco

visualizaLivrosLendo :: IO()
visualizaLivrosLendo = do
  Utils.printEspaco
  l <- listarLivrosLendo
  putStrLn (listarLivros (l))
  Utils.printEspaco

imprimeTodosLivros :: IO ()
imprimeTodosLivros = do
  putStrLn(listarLivros livros)


listarLivros :: [Livro] -> String
listarLivros [] = ""
listarLivros (x:xs) = toStringLivro x ++ ['\n'] ++ listarLivros xs

listarLivrosNotas :: [Livro] -> [Int] -> String
listarLivrosNotas [] [] = ""
listarLivrosNotas (x:xs) (y:ys) = toStringLivro x ++ " - Nota : " ++ show y ++ ['\n'] ++ listarLivrosNotas xs ys

toStringLivro :: Livro -> String
toStringLivro (Livro {indice = i, nome = n, genero = g, ano = a, sinopse = s, editora = e, autor = au, nPaginas = np}) = show i ++ " - " ++ n ++ " - " ++ au ++ " - " ++ a

toStringLivroDetail :: Livro -> String
toStringLivroDetail (Livro {indice = i, nome = n, genero = g, ano = a, sinopse = s, editora = e, autor = au, nPaginas = np}) = "Id: " ++ show i ++ "\nNome: " ++ n ++ "\nGenero: " ++ g ++ "\nAno: " ++ a ++ "\nSinopse: " ++ s ++ "\nEditora: " ++ e ++ "\nAutor: " ++ au ++ "\nNumero de paginas: " ++ show np

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

finalizaLivro :: Int -> Int -> IO()
finalizaLivro i n = do
  removerLendo i
  addLivroFinalizado i
  addNota n

addNota :: Int -> IO()
addNota n = appendFile "notas.txt" (intToFileContent n)

notas :: IO [Int]
notas = do
  conteudo <- readFile "notas.txt"
  let linhas = lines conteudo
  let indexes = fmap (read::String->Int) linhas
  return indexes

addLivroFinalizado :: Int -> IO ()
addLivroFinalizado i = appendFile "finalizado.txt" (intToFileContent i)

listarLivrosFinalizados :: IO [Livro]
listarLivrosFinalizados = do
  ls <- finalizados
  return $ filtraLivros ls livros []

filtraLivros :: [Int] -> [Livro] -> [Livro] -> [Livro]
filtraLivros [] livros livrosFiltrados = livrosFiltrados
filtraLivros (x:xs) livros livrosFiltrados = filtraLivros xs livros (livrosFiltrados ++ [getLivroByIndex x livros])

-- Lista Desejos

enviarLivroDesejado :: IO()
enviarLivroDesejado = do
    Utils.printEspaco
    imprimeTodosLivros
    putStrLn "== Digite o id do livro que deseja ler: "
    i <- getLine
    addLivroDesejo (read i)
    Utils.printEspaco


addLivroDesejo :: Int -> IO ()
addLivroDesejo i = appendFile "listaDesejos.txt" (intToFileContent i)

desejos :: IO [Int]
desejos = do
  conteudo <- readFile "listaDesejos.txt"
  let linhas = lines conteudo
  let indexes = fmap (read::String->Int) linhas
  return indexes

listarDesejos :: IO [Livro]
listarDesejos = do
  ls <- desejos
  return $ filtraLivros ls livros []

visualizaDesejos :: IO()
visualizaDesejos = do
  Utils.printEspaco
  l <- listarDesejos
  putStrLn (listarLivros (l))
  Utils.printEspaco

cadastrarLivro :: IO()
cadastrarLivro = do
    Utils.printEspaco
    putStrLn "Livros disponiveis: "
    imprimeTodosLivros
    putStrLn "Digite o id correspondente ao livro que quer começar a ler:"
    i <- getLine
    addLivroLendo (read i)
    Utils.printEspaco
