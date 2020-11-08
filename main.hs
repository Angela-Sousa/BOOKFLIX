module Main where
import qualified Utils as Utils
import System.IO
import System.Directory
import Data.List.Unique

-- MENU

main :: IO()
main = do
    putStrLn (Utils.logo)
    menu

menu :: IO ()
menu = do
    putStrLn "1 - Adicionar novo ebook na estante de leitura: "
    putStrLn "2 - Visualizar lista de ebooks - Lendo: "
    putStrLn "3 - Visualizar lista de ebooks - Finalizados: "
    putStrLn "4 - Marcar um ebook como finalizado: "
    putStrLn "5 - Adicionar ebook à lista de desejos de leitura: "
    putStrLn "6 - Visualizar lista de desejos: "
    putStrLn "7 - Visuaizar informações sobre ebooks do sistema: "
    putStrLn "8 - Pedir recomendação de livro: "
    putStrLn "0 - Para Sair: "
    putStrLn "\nOpcao: "
    opcao <- getLine
    opcaoEscolhida (read opcao)

-- OPÇÕES

opcaoEscolhida :: Int -> IO()
opcaoEscolhida opcao
    | opcao == 1 = do {adicionarLivro ; menu}
    | opcao == 2 = do {visualizaLivrosLendo ; menu}
    | opcao == 3 = do {visualizaLivrosFinalizados; menu}
    | opcao == 4 = do {marcaFinalizado; menu}
    | opcao == 5 = do {enviarLivroDesejado; menu}
    | opcao == 6 = do {visualizaDesejos; menu}
    | opcao == 7 = do {livroDetail; menu}
    | opcao == 8 = do {fazRecomendacao; menu}
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
} deriving (Show, Eq)

-- Já disponíveis no sistema

livros = [Livro { indice = 0, nome = "Harry potter e o calice de fogo", genero = "Fantasia", ano = "2001", sinopse = "A chegada na Escola e a notícia de que esta sediará o importante Torneio Tribruxo.", editora = "Rocco", autor = "J.K. Rowling", nPaginas = 584},
          Livro { indice = 1, nome = "Harry potter e o enigma do principe", genero = "Fantasia", ano = "2005", sinopse = "Um misterioso príncipe mestiço ajuda Harry em sua aula de Poções.", editora = "Rocco", autor = "J.K. Rowling", nPaginas = 512},
          Livro { indice = 2, nome = "A revolucao dos bichos: Um conto de fadas", genero = "Infantil", ano = "2007", sinopse = "Intrigante narrativa protagonizada geralmente por animais, mas que reflete ações humanas com algum ensinamento de cunho moral." , editora = "Companhia das Letras", autor = "George Orwell", nPaginas = 152},
          Livro { indice = 3, nome = "O iluminado", genero = "Terror/Romance", ano = "2012", sinopse = "A luta assustadora entre dois mundos. Um menino e o desejo assassino de poderosas forças malignas." , editora = "Suma", autor = " Stephen King", nPaginas = 464 },
          Livro { indice = 4, nome = "Sherlock Holmes - Um estudo em vermelho", genero = "Acao e Aventura", ano = "2019", sinopse = "Holmes é chamado para solucionar o caso de um homem que foi encontrado morto, com uma expressão de terror, mas que não apresenta ferimentos, apenas manchas de sangue pelo corpo." , editora = "Principis", autor = "Arthur Conan Doyle", nPaginas = 176 },
          Livro { indice = 5, nome = "Dom Quixote", genero = "Acao e Aventura", ano = "2019", sinopse = "Um velho fidalgo espanhol adora ler histórias de cavalaria. De tão influenciado por elas, enlouquece e sai em busca de aventuras memoráveis com Sancho Pança, seu fiel escudeiro.", editora = "Atica", autor = "Miguel de Cervantes", nPaginas = 120},
          Livro { indice = 6, nome = "O Conde de Monte Cristo", genero = "Literatura e Ficcao", ano = "2012", sinopse = "Traições, denúncias anônimas, tesouros fabulosos, envenenamentos, vinganças e muito suspense.", editora = "Clássicos Zahar", autor = "Alexandre Dumas", nPaginas = 1664},
          Livro { indice = 7, nome = "O Senhor dos Anéis: A Sociedade do Anel", genero = "Ficcao Cientifica Fantasia", ano = "2019", sinopse = "A Sociedade do Anel começa no Condado, a região rural do oeste da Terra-média onde vivem os diminutos e pacatos hobbits.", editora = "HarperCollins", autor = "J.R.R. Tolkien", nPaginas = 576},
          Livro { indice = 8, nome = "Hamlet", genero = "Literatura e Ficcao", ano = "2010", sinopse = "Obra clássica permanentemente atual pela força com que trata de problemas fundamentais da condição humana. A obsessão de uma vingança onde a dúvida e o desespero concentrados nos monólogos do príncipe Hamlet adquirem uma impressionante dimensão trágica.", editora = "Martin Claret", autor = "William Shakespeare", nPaginas = 194},
          Livro { indice = 9, nome = "Odisseia", genero = "Ficcao", ano = "2011", sinopse = "Em seu tratado conhecido como Poética, Aristóteles escreve: “Um homem encontra-se no estrangeiro há muitos anos; está sozinho e o deus Posêidon o mantém sob vigilância hostil. Em casa, os pretendentes à mão de sua mulher estão esgotando seus recursos e conspirando para matar seu filho. Então, após enfrentar tempestades e sofrer um naufrágio, ele volta para casa, dá-se a conhecer e ataca os pretendentes: ele sobrevive e os pretendentes são exterminados”", editora = "Penguin", autor = "Homero", nPaginas = 576},
          Livro { indice = 10, nome = "Alice no País das Maravilhas", genero = "Ficcao", ano = "2019", sinopse = "Uma menina, um coelho e uma história capazes de fazer qualquer um de nós voltar a sonhar.", editora = "Darkside", autor = "Lewis Carroll", nPaginas = 80},
          Livro { indice = 11, nome = "A Guerra dos Tronos : As Crônicas de Gelo e Fogo", genero = "Fantasia e Ficcao", ano = "2019", sinopse = "O verão pode durar décadas. O inverno, toda uma vida. E a guerra dos tronos começou.", editora = "Suma", autor = "George R. R. Martin", nPaginas = 600},
          Livro { indice = 12, nome = "Jogos Vorazes", genero = "Ficcao Cientifica Distopico", ano = "2012", sinopse = "Na abertura dos Jogos Vorazes, a organização não recolhe os corpos dos combatentes caídos e dá tiros de canhão até o final. Cada tiro, um morto. Onze tiros no primeiro dia. Treze jovens restaram, entre eles, Katniss.", editora = "Rocco", autor = "Suzanne Collins", nPaginas = 400},
          Livro { indice = 13, nome = "Cidade do Fogo Celestial", genero = "Literatura e Ficcao", ano = "2014", sinopse = "Quando uma das mais surpreendentes traições vem à luz, Clary, Jace, Izzy, Simon e Alec precisam fugir ― mesmo que sua jornada os leve aos mais assustadores reinos inferiores, onde nenhum Caçador de Sombras pisou antes e de onde nenhum ser humano jamais retornou.", editora = "Galera", autor = "Cassandra Clare", nPaginas = 532},
          Livro { indice = 14, nome = "Último sacrifício", genero = "Fantasia e Romance", ano = "2013", sinopse = "Todos os caminhos levaram até aqui. Todos os desafios foram apenas preparações para a derradeira neblina tingida de sangue que se aproxima no horizonte.Envolta num mundo de paixão e morte, Rose aguarda a sua sentença após o assassinato de Tatiana, pelo qual foi injustamente acusada.", editora = "HarperCollins Brasil", autor = "Richelle Mead", nPaginas = 613},
          Livro { indice = 15, nome = "Os Homens que Não Amavam as Mulheres", genero = "Literatura e Ficcao", ano = "2015", sinopse = "Os homens que não amavam as mulheres é uma fascinante e assustadora aventura vivida por um veterano jornalista e uma jovem e genial hacker cujo comportamento social beira o autismo. A riqueza dos personagens, a narrativa ágil e inteligente e os surpreendentes desdobramentos da história formam um conjunto magnífico e revelam Stieg Larsson como um grande mestre da literatura de suspense", editora = "Companhia das Letras", autor = "Stieg Larsson", nPaginas = 528}]


getGeneros :: [Livro] -> [String]
getGeneros [] = []
getGeneros (x:xs) = [genero x] ++ (getGeneros xs)

listGeneros :: [String]
listGeneros = unique (getGeneros livros)

listarGeneros :: [String] -> String
listarGeneros [] = ""
listarGeneros (x:xs) = x ++ "\n" ++ listarGeneros xs

visualizaGeneros :: IO()
visualizaGeneros = putStrLn (listarGeneros listGeneros)

filterGeneros :: String -> [Livro]
filterGeneros g = filterGeneros' livros g []

filterGeneros' :: [Livro] -> String -> [Livro] -> [Livro]
filterGeneros' [] g l = l
filterGeneros' (x:xs) g l
  | genero x == g = l ++ [x] ++ (filterGeneros' xs g l)
  | otherwise = (filterGeneros' xs g l)

getRecomendacao :: [Livro] -> String
getRecomendacao [] = "Não temos uma recomendação no momento :("
getRecomendacao (x:xs) = toStringLivro x

fazRecomendacao :: IO ()
fazRecomendacao = do
  Utils.printEspaco
  visualizaGeneros
  putStrLn "Digite o genero que voce deseja recomendação: "
  g <- getLine
  let l = filterGeneros g
  lendo <- listarLivrosLendo
  finalizados <- listarLivrosFinalizados
  let f = filtraLivrosLidosFinalizados l lendo finalizados
  putStrLn (getRecomendacao f)
  Utils.printEspaco

filtraLivrosLidosFinalizados :: [Livro] -> [Livro] -> [Livro] -> [Livro]
filtraLivrosLidosFinalizados [] lendo finalizados = []
filtraLivrosLidosFinalizados (x:xs) lendo finalizados
  | elem x lendo || elem x finalizados = filtraLivrosLidosFinalizados xs lendo finalizados
  | otherwise = [x] ++ filtraLivrosLidosFinalizados xs lendo finalizados


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

adicionarLivro :: IO()
adicionarLivro = do
    Utils.printEspaco
    putStrLn "Livros disponiveis: "
    imprimeTodosLivros
    putStrLn "Digite o id correspondente ao livro que quer começar a ler:"
    i <- getLine
    addLivroLendo (read i)
    Utils.printEspaco
