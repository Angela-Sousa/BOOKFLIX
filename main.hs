module Main where
import qualified Utils as Utils
--import System.Console.ANSI
import System.IO

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
