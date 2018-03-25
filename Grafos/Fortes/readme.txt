-------------------------------------------------------------------------------
Alunos
-------------------------------------------------------------------------------
Diego Hirt Santos Rodrigues - GRR20120737
-------------------------------------------------------------------------------
Informações
-------------------------------------------------------------------------------
Foi usada a biblioteca cgraph para armazenar,ler,imprimir e andar no grafo.

Para procurar as componentes foi usado o algoritmo de Kosaraju.
A idéia é :

1-Criar uma pilha vazia;

2-Fazer uma busca DFS(chamei de empilha) onde ao final da recursão adiciona 
    vértice na pilha.

3-Transpor o grafo.(Nesse caso olhei somente para os vértices de entrada,como
    se estivesse mudando a direção).
    
4-Enquanto a pilha não está vazia
    - Remover vértice da pilha
    - Se vértice não foi visitado(na nova busca),fazer uma dfs a partir dele.
        os vértices que ele está ligado formam uma componente conexa.
