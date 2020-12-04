:- initialization(main).


:- dynamic(livro/8).
:- dynamic(adicionado/1).
:- dynamic(desejado/1).
:- dynamic(finalizado/1).


livro(0, "Harry potter e o calice de fogo", "Fantasia", "2001", "A chegada na Escola e a notícia de que esta sediará o importante Torneio Tribruxo.", "Rocco", "J.K. Rowling", 584).
livro(1, "Harry potter e o enigma do principe", "Fantasia", "2005", "Um misterioso príncipe mestiço ajuda Harry em sua aula de Poções.", "Rocco", "J.K. Rowling", 512).
livro(2, "A revolucao dos bichos: Um conto de fadas", "Infantil", "2007", "Intrigante narrativa protagonizada geralmente por animais, mas que reflete ações humanas com algum ensinamento de cunho moral." , "Companhia das Letras", "George Orwell", 152).
livro(3, "O iluminado", "Terror/Romance", "2012", "A luta assustadora entre dois mundos. Um menino e o desejo assassino de poderosas forças malignas." , "Suma", "Stephen King",  464 ).
livro(4, "Sherlock Holmes - Um estudo em vermelho", "Acao e Aventura", "2019", "Holmes é chamado para solucionar o caso de um homem que foi encontrado morto, com uma expressão de terror, mas que não apresenta ferimentos, apenas manchas de sangue pelo corpo." , "Principis", "Arthur Conan Doyle", 176 ).
livro(5, "Dom Quixote", "Acao e Aventura", "2019", "Um velho fidalgo espanhol adora ler histórias de cavalaria. De tão influenciado por elas, enlouquece e sai em busca de aventuras memoráveis com Sancho Pança, seu fiel escudeiro.", "Atica", "Miguel de Cervantes", 120).
livro(6, "O Conde de Monte Cristo", "Literatura e Ficcao", "2012", "Traições, denúncias anônimas, tesouros fabulosos, envenenamentos, vinganças e muito suspense.", "Clássicos Zahar", "Alexandre Dumas", 1664).
livro(7, "O Senhor dos Anéis: A Sociedade do Anel", "Ficcao Cientifica Fantasia", "2019", "A Sociedade do Anel começa no Condado, a região rural do oeste da Terra-média onde vivem os diminutos e pacatos hobbits.", "HarperCollins", "J.R.R. Tolkien", 576).
livro(8, "Hamlet", "Literatura e Ficcao", "2010", "Obra clássica permanentemente atual pela força com que trata de problemas fundamentais da condição humana. A obsessão de uma vingança onde a dúvida e o desespero concentrados nos monólogos do príncipe Hamlet adquirem uma impressionante dimensão trágica.", "Martin Claret", "William Shakespeare", 194).
livro(9, "Odisseia", "Ficcao", "2011", "Em seu tratado conhecido como Poética, Aristóteles escreve: “Um homem encontra-se no estrangeiro há muitos anos; está sozinho e o deus Posêidon o mantém sob vigilância hostil. Em casa, os pretendentes à mão de sua mulher estão esgotando seus recursos e conspirando para matar seu filho. Então, após enfrentar tempestades e sofrer um naufrágio, ele volta para casa, dá-se a conhecer e ataca os pretendentes: ele sobrevive e os pretendentes são exterminados”", "Penguin", "Homero", 576).
livro(10, "Alice no País das Maravilhas", "Ficcao", "2019", "Uma menina, um coelho e uma história capazes de fazer qualquer um de nós voltar a sonhar.", "Darkside", "Lewis Carroll", 80).
livro(11, "A Guerra dos Tronos : As Crônicas de Gelo e Fogo", "Fantasia e Ficcao", "2019", "O verão pode durar décadas. O inverno, toda uma vida. E a guerra dos tronos começou.", "Suma", "George R. R. Martin", 600).
livro(12, "Jogos Vorazes", "Ficcao Cientifica Distopico", '2012', "Na abertura dos Jogos Vorazes, a organização não recolhe os corpos dos combatentes caídos e dá tiros de canhão até o final. Cada tiro, um morto. Onze tiros no primeiro dia. Treze jovens restaram, entre eles, Katniss.", "Rocco", "Suzanne Collins", 400).
livro(13, "Cidade do Fogo Celestial", "Literatura e Ficcao", "2014", "Quando uma das mais surpreendentes traições vem à luz, Clary, Jace, Izzy, Simon e Alec precisam fugir ― mesmo que sua jornada os leve aos mais assustadores reinos inferiores, onde nenhum Caçador de Sombras pisou antes e de onde nenhum ser humano jamais retornou.", "Galera", "Cassandra Clare", 532).
livro(14, "Último sacrifício", "Fantasia e Romance", "2013", "Todos os caminhos levaram até aqui. Todos os desafios foram apenas preparações para a derradeira neblina tingida de sangue que se aproxima no horizonte.Envolta num mundo de paixão e morte, Rose aguarda a sua sentença após o assassinato de Tatiana, pelo qual foi injustamente acusada.", "HarperCollins Brasil", "Richelle Mead", 613).
livro(15, "Os Homens que Não Amavam as Mulheres", "Literatura e Ficcao", "2015","Os homens que não amavam as mulheres é uma fascinante e assustadora aventura vivida por um veterano jornalista e uma jovem e genial hacker cujo comportamento social beira o autismo. A riqueza dos personagens, a narrativa ágil e inteligente e os surpreendentes desdobramentos da história formam um conjunto magnífico e revelam Stieg Larsson como um grande mestre da literatura de suspense","Companhia das Letras", "Stieg Larsson", 528).    


opcao(0) :- halt.

	
opcao(1) :- print(),
			write("1 - Adicionar novo ebook na estante de leitura "), nl,
			writeln("Digite o codigo do livro a adicionar: "), nl,
			read(Codigo),
			adicionaLivro(Codigo), nl.			

opcao(2) :- writeln("2 - Visualizar lista de ebooks - Lendo "), nl,
			findall(Nome, adicionado(livro(_,Nome,_,_,_,_,_,_)), Adicionados), nl,
			imprimeLendo(Adicionados), nl.
					
opcao(3) :- writeln("3 - Visualizar lista de ebooks - Finalizados "), nl,
			findall(Nome, finalizado(livro(_,Nome,_,_,_,_,_,_)), Finalizados), nl,
			imprimeFinalizado(Finalizados), nl.
	
opcao(4) :- writeln("4 - Marcar um ebook como finalizado: "), nl,
			findall(Nome, adicionado(livro(_,Nome,_,_,_,_,_,_)), Adicionados), nl,
			marcaFinalizado(Adicionados), nl.
		
opcao(5) :- print(),
			write("5 - Adicionar ebook à lista de desejos de leitura "), nl,
			writeln("Digite o codigo do livro que deseja ler: "), nl,
			read(Codigo),
			adicionaListaDesejo(Codigo), nl.

opcao(6) :- writeln("2 - Visualizar lista de ebooks - Lendo "), nl,
			findall(Nome, desejado(livro(_,Nome,_,_,_,_,_,_)), Desejados), nl,
			imprimeDesejados(Desejados), nl.
	
opcao(7) :- print(),
			writeln("7 - Visualizar informações sobre ebooks do sistema "), nl,
			writeln("Digite o codigo do livro: "), nl,
			read(Codigo),
			info(Codigo), nl.
				
menu() :- 

	writeln("Use sempre um ponto no final de cada instrucao "), nl,  
	writeln("1 - Adicionar novo ebook na estante de leitura "),
	writeln("2 - Visualizar lista de ebooks - Lendo "),
	writeln("3 - Visualizar lista de ebooks - Finalizados "),
	writeln("4 - Marcar um ebook como finalizado "),
	writeln("5 - Adicionar ebook à lista de desejos de leitura "),
	writeln("6 - Visualizar lista de desejos "),
	writeln("7 - Visualizar informações sobre ebooks do sistema "),
	writeln("0 - Sair"), nl,
	writeln("Opcao: "), nl,
	read(Op),
	opcao(Op),
	menu().

main :-

logo(),
menu().

info(Codigo):-
	call(livro(Codigo, Nome, Genero, Ano, Sinopse, Editora, Autor,NPaginas)),
	write("Nome: "),
	writeln(Nome),
	write("Gênero: "),
	writeln(Genero),
	write("Ano: "),
	writeln(Ano),
	write("Sinopse: "),
	writeln(Sinopse),
	write("Editora: "),
	writeln(Editora),
	write("Autor: "),
	writeln(Autor),
	write("Numero de Páginas: "),
	writeln(NPaginas).

listarLivros([],_).
listarLivros([Head|Tail], Codigo) :-
	write(Codigo), 
	write(" - "), 
	writeln(Head), 
	Codigo1 is Codigo + 1, 
	listarLivros(Tail, Codigo1). 
  

print() :-
	writeln("Livros:"), 
	findall(Nome, livro(_,Nome,_,_,_,_,_,_), Livros), 
	listarLivros(Livros, 0), nl.
	