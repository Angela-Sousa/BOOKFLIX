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
    clearScreen  
    menu
  
menu :: IO ()
menu = do
    clearScreen
    putStrLn "1 - Cadastrar novo ebook: "
    putStrLn "2 - Visualizar lista de ebooks lidos: "
    putStrLn "3 - Visualizar lista de ebooks finalizados: "
    putStrLn "4 - Marcar um ebook como finalizado: "
    putStrLn "5 - Dar nota à um ebook: "
    putStrLn "6 - Adicionar livro à lista de desejos de leitura: "
    putStrLn "7 - Visualizar lista de desejos: "
    putStrLn "8 - Visuaizar informações sobre ebooks do sistema: " -- aqui pega só os estáticos
    putStrLn "8 - Visuaizar informações sobre ebooks cadastrados: " -- aqui pega os cadastrados, tem q ser uma lista variável
    putStrLn "Ou Digite 0 Para Sair: " 
    putStrLn "\nOpcao: "
    opcao <- getLine
    opcaoEscolhida (read opcao)

-- OPÇÕES 

opcaoEscolhida :: Int -> IO()
opcaoEscolhida opcao 
    | opcao == 1 = do {cadastrarLivro}
    | opcao == 2 = do {{-visualizaLivrosLidos-} ; menu}
    | opcao == 3 = do {{-listarLivrosFinalizados-}; menu}
    | opcao == 4 = do {{-marcaFinalizado-}; menu}
    | opcao == 5 = do {{-notaLivro-}; menu}
    | opcao == 6 = do {enviarLivroDesejado}    
    | opcao == 7 = do {listarListaDesejos}  
    | opcao == 8 = do {listarLivrosCadastrados} -- aqui tem um conflito: para cadastrar tem q ser uma lista variável, 
    | opcao == 9 = do {imprimeTodosLivros} -- fiz o cadastrar e deixei o estático, mas temos q ver como unir, se precisar
    | opcao == 0 = do {putStrLn"Saindo..."}
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

-- Já disponíveis no sistema

livros = [Livro { nome = "Harry potter e o calice de fogo", genero = "Fantasia", ano = "2001", sinopse = "A chegada na Escola e a notícia de que esta sediará o importante Torneio Tribruxo.", editora = "Rocco", autor = "J.K. Rowling", nPaginas = 584 }, 
          Livro { nome = "Harry potter e o enigma do principe", genero = "Fantasia", ano = "2005", sinopse = "Um misterioso príncipe mestiço ajuda Harry em sua aula de Poções.", editora = "Rocco", autor = "J.K. Rowling", nPaginas = 512 },
          Livro { nome = "A revolucao dos bichos: Um conto de fadas", genero = "Infantil", ano = "2007", sinopse = "Intrigante narrativa protagonizada geralmente por animais, mas que reflete ações humanas com algum ensinamento de cunho moral." , editora = "Companhia das Letras", autor = "George Orwell", nPaginas = 152 },
          Livro { nome = "O iluminado", genero = "Terror/Romance", ano = "2012", sinopse = "A luta assustadora entre dois mundos. Um menino e o desejo assassino de poderosas forças malignas." , editora = "Suma", autor = " Stephen King", nPaginas = 464 },
          Livro { nome = "Sherlock Holmes - Um estudo em vermelho", genero = "Acao e Aventura", ano = "2019", sinopse = "Holmes é chamado para solucionar o caso de um homem que foi encontrado morto, com uma expressão de terror, mas que não apresenta ferimentos, apenas manchas de sangue pelo corpo." , editora = "Principis", autor = "Arthur Conan Doyle", nPaginas = 176 }]

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

-- Lista Desejos

enviarLivroDesejado :: IO()
enviarLivroDesejado = do
    Utils.printEspaco
    putStr "== Digite o nome do livro que deseja ler: "
    nomeLivro <- getLine
    appendFile "listaDesejos.txt" (nomeLivro ++ "\n")
    Utils.printEspaco


listarListaDesejos :: IO()
listarListaDesejos = do
    Utils.printEspaco
    putStrLn "==== Sua lista de desejos: ====\n"  
    listaDesejos <- readFile "listaDesejos.txt"
    putStrLn listaDesejos
    Utils.printEspaco


cadastrarLivro :: IO()
cadastrarLivro = do
    Utils.printEspaco
    putStr "== Digite o nome do livro que deseja cadastrar: "
    nome <- getLine
    putStr "== Digite o autor do livro que deseja cadastrar: "
    autor <- getLine
    putStr "== Digite o ano do livro que deseja cadastrar: "
    ano <- getLine
    putStr "== Digite a editora do livro que deseja cadastrar: "
    editora <- getLine
    putStr "== Digite a sinopse do livro que deseja cadastrar: "
    sinopse <- getLine
    putStr "== Digite o numero de paginas do livro que deseja cadastrar: "
    nPaginas <- getLine
    appendFile "listaLivros.txt" (nome ++ " - " ++ autor  ++ " - " ++ ano  ++ " - " ++ editora  ++ " - " ++ sinopse  ++ " - " ++ nPaginas  ++ " \n")
    Utils.printEspaco

listarLivrosCadastrados :: IO()
listarLivrosCadastrados = do
    Utils.printEspaco
    putStrLn "==== Sua lista de livros: ====\n"  
    listaLivros <- readFile "listaLivros.txt"
    putStrLn listaLivros
    Utils.printEspaco